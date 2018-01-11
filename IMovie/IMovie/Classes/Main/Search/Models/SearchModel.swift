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
    
    /// 接口返回类型为 int，如果后台后来改成了 string 类型，则解析失败！
    var id: Int?
    var images: [String]?
    var title: String?
    var type: Int?
    var image: String?
    /// 该字段接口中并没有，写成可选
    var multipic: Bool? = false
    
}
