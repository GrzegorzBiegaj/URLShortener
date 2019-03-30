//
//  MockStorage.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 29.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import Foundation

struct MockStorageShorteners {
    var items: [ShortURL]
}

extension MockStorageShorteners: InMemoryStorable { }
