//
//  ShortenerColorPalette.swift
//  URLShortener
//
//  Created by Grzesiek on 29/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

enum ShortenerColor {
    
    case lightBlue, blue, mediumBlue, darkBlue, green, lightGray, white
    
    var color: UIColor {
        
        switch self {
        case .lightBlue:
            return UIColor(red: 162/255, green: 202/255, blue: 249/255, alpha: 1.0)
        case .blue:
            return UIColor(red: 33/255, green: 96/255, blue: 177/255, alpha: 1.0)
        case .mediumBlue:
            return UIColor(red: 59/255, green: 130/255, blue: 221/255, alpha: 1.0)
        case .darkBlue:
            return UIColor(red: 41/255, green: 68/255, blue: 98/255, alpha: 1.0)
        case .green:
            return UIColor(red: 116/255, green: 225/255, blue: 199/255, alpha: 1.0)
        case .lightGray:
            return UIColor(white: 223/255, alpha: 1.0)
        case .white:
            return .white
        }
    }
}
