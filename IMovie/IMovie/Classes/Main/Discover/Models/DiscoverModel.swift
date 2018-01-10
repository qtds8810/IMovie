//
//  DiscoverModel.swift
//  IMovie
//
//  Created by 左得胜 on 2018/1/4.
//  Copyright © 2018年 zds. All rights reserved.
//

import Foundation

struct DiscoverModel: Decodable {
    // TODO: - 后期直接优化成 string
    var vote_average: Double?
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var title: String?
    // TODO: - 后期直接优化成 string
    var popularity: Double?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    /// TODO: - 后期优化？
    var genre_ids: Array<Int>?
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    // TODO; - 后期直接优化成日期
    var release_date: String?
    
}
