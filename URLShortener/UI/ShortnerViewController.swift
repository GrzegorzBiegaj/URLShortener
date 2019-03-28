//
//  ShortnerViewController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class ShortnerViewController: UITableViewController {

    let shortenerController = ShortenerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shortenerController.getShortenerData { (response) in
            switch response {
            case .success(let shortener):
                print (shortener)
            case .error(let error):
                print (error)
            }
        }

        
    }



}
