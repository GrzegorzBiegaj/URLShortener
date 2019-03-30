//
//  ShortnerViewController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class ShortnerViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "URL Shortener"
            titleLabel.textColor = ShortenerColor.blue.color
        }
    }

    @IBOutlet weak var urlTextField: UITextField! {
        didSet {
            urlTextField.placeholder = "Enter the link to shorten"
            urlTextField.delegate = self
            let height = urlTextField.bounds.height - 8
            let arrowView = ArrowView(frame: CGRect(x: 0, y: 0, width: height, height: height))
            arrowView.backgroundViewColor = ShortenerColor.green.color
            arrowView.arrowButtonColor = ShortenerColor.white.color
            arrowView.delegate = self
            urlTextField.rightViewMode = .always
            urlTextField.rightView = arrowView
        }
    }
    
    let shortenerController = ShortenerController()
    var model: [Shortener] = [] { didSet { tableView.reloadData(with: .automatic) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getShorteners()
    }
    
    fileprivate func configureVC() {
        tableView.tableHeaderView?.backgroundColor = ShortenerColor.lightBlue.color
        hideKeyboardWhenTappedAround()
    }
    
    func getShorteners() {
        shortenerController.getShortenerData { (response) in
            switch response {
            case .success(let shorteners):
                self.model = shorteners
            case .error(let error):
                print (error)
            }
        }
    }

    func addShortener() {
        guard let text = urlTextField.text else { return }
        shortenerController.storeShortenerData(url: text) { (response) in
            switch response {
            case .success(_):
                self.urlTextField.text = nil
                self.getShorteners()
            case .error(let error):
                print (error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortRI", for: indexPath)
        if let cell = cell as? URLTableViewCell {
            cell.configureCell(shortener: model[indexPath.row])
            cell.delegate = self
        }
        return cell
    }

}

// MARK: UITextFieldDelegate

extension ShortnerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addShortener()
        return true
    }
}

// MARK: ArrowViewDelegate

extension ShortnerViewController: ArrowViewDelegate {

    func onButtonTap(button: UIButton) {
        addShortener()
    }
}

// MARK: URLTableViewCellDelegate

extension ShortnerViewController: URLTableViewCellDelegate {

    func onUrlButtonTap(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
