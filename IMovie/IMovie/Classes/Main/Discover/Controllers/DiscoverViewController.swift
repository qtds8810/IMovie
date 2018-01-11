//
//  DiscoverViewController.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya

class DiscoverViewController: UIViewController {
    // MARK: - Property
    private let bag = DisposeBag()
    private lazy var viewModel = DiscoverViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        tableView.backgroundColor = kColor.groupTableViewBackground
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = kHeight.d50
        
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        /**
         设置 tableView 的 sectionHeaderHeight/sectionFooterHeight 注意事项【下面只针对sectionHeaderHeight说明，sectionFooterHeight同理】：
         - grouped 模式下【没有设置tableHeaderView，且不自定义 sectionHeaderView】：
            - 如果要正常生效，需要同时设置 sectionHeaderHeight 和其 UITableViewDelegate 的sectionHeight 代理方法！
            - 如果只设置了 sectionHeaderHeight 或者其代理方法中的一个，则第一个 section 的 headerHeight 会默认有 35 的行高；
         - grouped 模式下【设置了tableHeaderView不会有问题】：
         
         分析：经过测试，如果要自定义 sectionHeaderView，代理方法会先走 headerHeight 方法，然后走 sectionHeaderView 方法。如果要正常复用（包括第一个 section），则还需要设置 headerHeight 代理方法；如果不设置 headerHeight 代理方法，则自定义 view 的行高是不生效的；
         如果只是单纯的设置 sectionHeaderHeight，而不自定义 sectionHeaderView（即用系统默认的 sectionHeaderView），如果要正常复用（包括第一个 section）。需要同时设置 sectionHeaderHeight 和其 UITableViewDelegate 的sectionHeight 代理方法；如果只设置了两者中的任意一个，则第一个 sectionHeight 为0；
         
         */
        tableView.sectionHeaderHeight = kHeight.d50
        tableView.sectionFooterHeight = kHeight.d05
        /**
         group 模式下【没有自定义 sectionHeaderView】:
         - 如果 tableView 没有 tableHeaderView：则 tableview 的第一个 section 本身会自带35的高度，第一个设置sectionHeaderView 行高是不生效的；
         - 如果 tableView 有 tableHeaderView：则 tableview 的第一个 section 的高度为0，第一个设置sectionHeaderView 行高是不生效的；
         */
//        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        tableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: DiscoverTableViewCell.reuseID)
        
        return tableView
    }()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MultiplyCellEnum>>.init(configureCell:  { (_, tableView, indexPath, cellEnum) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTableViewCell.reuseID, for: indexPath) as! DiscoverTableViewCell
        
        return cell
        
    })
    
    /// 轮播图当前显示的 index
    var cycleIndex = 1
    let cycleImageWidth: CGFloat = kScreen.width - 40
    let cycleImageHeight: CGFloat = (kScreen.width - 40) * 169 / 300
    
    private lazy var tableHeaderView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: cycleImageWidth, height: cycleImageHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let tableHeaderView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: kScreen.width, height: cycleImageHeight), collectionViewLayout: flowLayout)
        tableHeaderView.register(UINib.init(nibName: "DiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DiscoverCollectionViewCell.reuseID)
        tableHeaderView.delegate = self
        tableHeaderView.dataSource = self
        tableHeaderView.showsVerticalScrollIndicator = false
        tableHeaderView.showsHorizontalScrollIndicator = false
        
        return tableHeaderView
    }()

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - Private Method
private extension DiscoverViewController {
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        let dataArr = [
            SectionModel.init(model: "Section 1", items: [
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810"),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810"),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810"),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810"),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810"),
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810")
                ]),
            SectionModel(model: "Section 2", items: [
                MultiplyCellEnum.detail(title: "性别", detail: "男"),
                MultiplyCellEnum.detail(title: "生日", detail: "点击设置生日"),
                MultiplyCellEnum.detail(title: "星座", detail: "天蝎座")
                ]),
            SectionModel(model: "Section 3", items: [
                MultiplyCellEnum.detail(title: "签名", detail: "点击设置签名")
                ])
        ]
        
        Observable.just(dataArr)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { (indexPath) in
                UIAlertController.show(message: "您点击了\(indexPath)")
            })
            .disposed(by: bag)
        
        // 轮播图
        tableView.tableHeaderView = tableHeaderView
        
        /*
         // 没有作用？？？
        let collectionDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, DiscoverModel>>(configureCell: { (_, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.reuseID, for: indexPath) as! DiscoverCollectionViewCell
            
            cell.showData(model: item)
            
            return cell
        })
        
        let items = Observable.just([
            SectionModel(model: "", items: viewModel.cycleItems)
            ])
        
        items.bind(to: tableHeaderView.rx.items(dataSource: collectionDataSource))
            .disposed(by: bag)
        
        */
        
        Observable<Int>.interval(5.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (index) in
                let num = self.viewModel.cycleItems.count - 2
                let aIndex = CGFloat(self.cycleIndex)
                
                UIView.animate(withDuration: kTime.duration, animations: {
                    self.tableHeaderView.contentOffset = CGPoint(x: self.cycleImageWidth * aIndex - 20, y: 0)
                }, completion: { (_) in
                    self.cycleIndex += 1
                    
                    if self.cycleIndex == num {
                        self.cycleIndex = 1
                        self.tableHeaderView.contentOffset = CGPoint(x: -20, y: 0)
                    }
                    
                })
                
            })
        .disposed(by: viewModel.bag)
        
        viewModel.reloadSubject.subscribe(onNext: { [unowned self] (reloadView) in
            switch reloadView {
            case .collection:
                QL1(self.viewModel.cycleItems.count)

                self.tableHeaderView.reloadData()
                self.tableHeaderView.contentOffset = CGPoint(x: self.cycleImageWidth - 20, y: 0)
            case .table:
                self.tableView.reloadData()
            }
        })
        .disposed(by: viewModel.bag)
        
        
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DiscoverViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return kHeight.d50
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kHeight.d05
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cycleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.reuseID, for: indexPath) as! DiscoverCollectionViewCell
        
        cell.showData(model: viewModel.cycleItems[indexPath.item])
        
        return cell
    }
}
