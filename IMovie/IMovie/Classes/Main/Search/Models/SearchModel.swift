//
//  SearchModel.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/10.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation

struct SearchModel: Codable {
    var date: String?
    var stories: [Search_StoryModel]?
    var top_stories: [Search_StoryModel]?
}

struct Search_StoryModel: Codable {
    var ga_prefix: String?
    var id: Int?
    var images: [String]?
    var title: String?
    var type: Int?
    var image: String?
//    var multipic: Bool = false
    
}
