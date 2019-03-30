//
//  UITableView+Animation.swift
//  URLShortener
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

extension UITableView {

    func reloadData(with animation: RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
