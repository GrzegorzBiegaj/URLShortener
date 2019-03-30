
//
//  ShortURL.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct ShortURL: Codable, Equatable {
    let id: Int
    let url: String
    let shortUrl: String
    let creationDate: Date

    static func ==(lhs: ShortURL, rhs: ShortURL) -> Bool {
        return lhs.id == rhs.id &&
            lhs.url == rhs.url &&
            lhs.shortUrl == rhs.shortUrl &&
            lhs.creationDate == rhs.creationDate
    }

}
