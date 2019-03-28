
//
//  Shortener.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct Shortener: Codable {
    let id: Int
    let url: String
    let shortUrl: String
    let creationDate: Date
}
