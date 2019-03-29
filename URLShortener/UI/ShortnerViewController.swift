//
//  ShortnerViewController.swift
//  URLShortener
//
//  Created by Grzegorz Biegaj on 28.03.19.
//  Copyright © 2019 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class ShortnerViewController: UITableViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    let shortenerController = ShortenerController()
    var model: [Shortener] = [] { didSet { tableView.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShorteners()
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

    @IBAction func onSendUrlButtonTap(_ sender: UIButton) {
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
