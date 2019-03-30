//
//  MockStorage.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 29.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct MockStorageShortURLs {
    var items: [ShortURL]
}

extension MockStorageShortURLs: InMemoryStorable { }
