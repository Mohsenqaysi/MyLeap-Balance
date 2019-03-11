//
//  ViewController.swift
//  MyLeap Balance
//
//  Created by Mohsen Qaysi on 10/6/18.
//  Copyright © 2018 Mohsen Qaysi. All rights reserved.
//

import UIKit

struct TripHistoryList: Codable {
    let trips: [Trip]
}
struct Trip: Codable {
    let cost, data: String
    let provider: String
    let time: String
    let transactionType: String
    let wasTopup: Bool
    
    enum CodingKeys: String, CodingKey {
        case cost, data, provider, time
        case transactionType = "transaction_type"
        case wasTopup = "was_topup"
    }
}

class ViewController: UIViewController {
    var tripHistoryList = [TripHistoryList]()
    var userName = ""
    @IBOutlet weak var tableView: UITableView!
    let tripHistoryURL = "https://leap-card-api.herokuapp.com/getCardHistory"
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    
    var viewControllerfullCardInfo: CardInfo?
    var balance = "€0.0" {
        didSet{
            balanceLabel.text = balance
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Wellcom \(userName)"
        guard let card = viewControllerfullCardInfo else { return }
        balance = card.travelBalance!
        fecthJSON(fullURL: tripHistoryURL)
    }
    
    // https://leap-card-api.herokuapp.com/getCardHistory
    //   let tripHistory = try? newJSONDecoder().decode(TripHistory.self, from: jsonData)
    func fecthJSON(fullURL: String) {
        self.indecator.startAnimating()
        guard let urlString = URL(string: fullURL) else {return}
        URLSession.shared.dataTask(with: urlString) { (jsonData, resp, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Faild to get data from server: \(error)")
                    return
                }
                guard let data = jsonData else {return}
                do {
                    let historyData = try JSONDecoder().decode(TripHistoryList.self, from: data)
                    self.tripHistoryList = [historyData]
                    self.tableView.reloadData()
                    self.indecator.stopAnimating()
                } catch let parsingError {
                    print("Error", parsingError.localizedDescription)
                }
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
        if segue.identifier == Identifiers.CardInfoViewControllerSegue {
            if let nextViewController = segue.destination as? CardInfoViewController {
                print("destination: \(nextViewController)")
                nextViewController.cardInfo = viewControllerfullCardInfo
                nextViewController.str = "Mohsen"
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tripHistoryList.first?.trips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cellID) as! TripTableViewCell
        
        let cost = tripHistoryList.first?.trips[indexPath.row].cost
        if cost?.first == "-" {
            cell.viewColor.backgroundColor = .red
        } else {
            cell.viewColor.backgroundColor = .green
        }
        cell.cost.text = cost
        cell.provider.text = tripHistoryList.first?.trips[indexPath.row].provider
        cell.transactionType.text = tripHistoryList.first?.trips[indexPath.row].transactionType
        cell.data.text = tripHistoryList.first?.trips[indexPath.row].data
        cell.time.text = tripHistoryList.first?.trips[indexPath.row].time
        
        return cell
    }
    
    
}
