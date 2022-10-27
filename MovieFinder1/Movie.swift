//
//  Movie.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import Foundation

struct Movie: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
}

struct ResultData: Codable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Movie]
}
