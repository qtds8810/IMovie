//
//  SearchTableViewCell.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/10.
//  Copyright © 2018年 zds. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Property
    static let reuseID = "SearchTableViewCellID"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightIV: UIImageView!
    
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public Method
    func showData(model: Search_StoryModel) {
        titleLabel.text = model.title
        rightIV.kf.setImage(with: URL.init(string: (model.images?.count ?? 0) > 0 ? model.images!.first! : "" ))
    }
    
}
