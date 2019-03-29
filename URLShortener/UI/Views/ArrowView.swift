//
//  ArrowView.swift
//  URLShortener
//
//  Created by Grzesiek on 29/03/2019.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

protocol ArrowViewDelegate: class {
    func onButtonTap(button: UIButton)
}

class ArrowView: UIView {

    weak var delegate: ArrowViewDelegate?
    
    var backgroundViewColor: UIColor = .white {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
        }
    }

    var arrowButtonColor: UIColor = .white {
        didSet {
            arrowButton.tintColor = arrowButtonColor
        }
    }
    
    @IBOutlet weak var contentView: ArrowView!
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
            backgroundView.clipsToBounds = true
            backgroundView.backgroundColor = backgroundViewColor
        }
    }
    
    @IBOutlet weak var arrowButton: UIButton! {
        didSet {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            arrowButton.setImage(imageView.image, for: .normal)
            arrowButton.tintColor = arrowButtonColor
        }
    }
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        delegate?.onButtonTap(button: sender)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func loadNib() {
        Bundle.main.loadNibNamed(String(describing: ArrowView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
