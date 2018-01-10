//
//  DiscoverCollectionViewCell.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit
import Kingfisher

class DiscoverCollectionViewCell: UICollectionViewCell {

    // MARK: - Property
    static let reuseID = "DiscoverCollectionViewCellID"
    
    /// 大图
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Public Method
    func showData(model: DiscoverModel) -> Void {
        imageView.kf.setImage(with: ImageURLTool.standardImage(path: model.backdrop_path, type: .backdrop), placeholder: nil, options: nil, progressBlock: nil) { (image, error, _, url) in
            print(image ?? "", error ?? "成功加载", url ?? "")
        }
        nameLabel.text = model.title
    }

}
