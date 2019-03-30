//
//  UIViewController+Alert.swift
//  URLShortener
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showOKAlert(withTitle title: String?, message: String, okButtonTitle: String, okAction: ((UIAlertAction) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: okAction))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

