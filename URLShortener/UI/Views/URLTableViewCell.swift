//
//  URLTableViewCell.swift
//  URLShortener
//
//  Created by Grzesiek on 30/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

protocol URLTableViewCellDelegate: class {
     func onUrlButtonTap(url: String)
}

class URLTableViewCell: UITableViewCell {

    weak var delegate: URLTableViewCellDelegate?
    private var url: String?
    
    @IBOutlet weak var roundedView: UIView! {
        didSet {
            roundedView.backgroundColor = ShortenerColor.white.color
            roundedView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = ShortenerColor.green.color
        }
    }
    @IBOutlet weak var urlLabel: UILabel! {
        didSet {
            urlLabel.textColor = ShortenerColor.darkBlue.color
        }
    }
    @IBOutlet weak var shortURLButton: UIButton! {
        didSet {
            let offset: CGFloat = 10
            shortURLButton.backgroundColor = .clear
            shortURLButton.layer.cornerRadius = (shortURLButton.bounds.height + offset) / 2
            shortURLButton.layer.borderWidth = 1
            shortURLButton.layer.borderColor = ShortenerColor.lightGray.color.cgColor
            shortURLButton.contentEdgeInsets = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset * 2)
            shortURLButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
            shortURLButton.setImage(UIImage(named: "arrow")?.scaled(rect: CGRect(x: 0, y: 0, width: offset * 2, height: offset * 2)), for: .normal)
            shortURLButton.setTitleColor(ShortenerColor.mediumBlue.color, for: .normal)
            shortURLButton.tintColor = ShortenerColor.darkBlue.color
        }
    }
    
    @IBAction func onUrlButtonTap(_ sender: UIButton) {
        guard let url = url else { return }
        delegate?.onUrlButtonTap(url: url)
    }
    
    func configureCell(shortener: ShortURL) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = dateFormatter.string(from: shortener.creationDate)
        urlLabel.text = shortener.url
        shortURLButton.setTitle(shortener.shortUrl, for: .normal)
        url = shortener.shortUrl
    }

}
