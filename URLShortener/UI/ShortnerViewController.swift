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
            titleLabel.textColor = ShortenerColor.darkBlue.color
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
    var model: [Shortener] = [] { didSet { tableView.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getShorteners()
    }
    
    fileprivate func configureVC() {
        tableView.tableHeaderView?.backgroundColor = ShortenerColor.blue.color
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
        cell.textLabel?.text = model[indexPath.row].url
        cell.detailTextLabel?.text = model[indexPath.row].shortUrl
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
