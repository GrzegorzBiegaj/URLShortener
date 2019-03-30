//
//  ShortnerViewController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class ShortnerViewController: UITableViewController {

    // MARK: Outlets
    
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
    
    // MARK: Private vars
    
    fileprivate let shortURLrController = ShortURLController()
    fileprivate var model: [ShortURL] = [] { didSet { tableView.reloadData(with: .automatic) } }
    
    // MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        getShortURLs()
    }
    
    // MARK: Private methods
    
    fileprivate func configureVC() {
        tableView.tableHeaderView?.backgroundColor = ShortenerColor.lightBlue.color
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: ShortURLController requests
    
    fileprivate func getShortURLs() {
        shortURLrController.getShortURLData { (response) in
            switch response {
            case .success(let shortURLs):
                self.model = shortURLs
            case .error(let error):
                self.showOKAlert(withTitle: "Error", message: error.errorDescription, okButtonTitle: "OK")
            }
        }
    }

    fileprivate func addShortURL() {
        guard let text = urlTextField.text else { return }
        shortURLrController.storeShortURLData(url: text) { (response) in
            switch response {
            case .success(_):
                self.urlTextField.text = nil
                self.getShortURLs()
            case .error(let error):
                self.showOKAlert(withTitle: "Error", message: error.errorDescription, okButtonTitle: "OK")
            }
        }
    }
    
    fileprivate func deleteShortURL(id: Int) {
        shortURLrController.deleteShortURLData(id: id) { (response) in
            switch response {
            case .success(_):
                self.getShortURLs()
            case .error(let error):
                self.showOKAlert(withTitle: "Error", message: error.errorDescription, okButtonTitle: "OK")
            }
        }
    }
    
    // MARK: UITableView support
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortRI", for: indexPath)
        if let cell = cell as? URLTableViewCell {
            cell.configureCell(shortURL: model[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteShortURL(id: model[indexPath.row].id)
        }
    }
}

// MARK: UITextFieldDelegate

extension ShortnerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addShortURL()
        return true
    }
}

// MARK: ArrowViewDelegate

extension ShortnerViewController: ArrowViewDelegate {

    func onButtonTap(button: UIButton) {
        addShortURL()
    }
}

// MARK: URLTableViewCellDelegate

extension ShortnerViewController: URLTableViewCellDelegate {

    func onUrlButtonTap(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
