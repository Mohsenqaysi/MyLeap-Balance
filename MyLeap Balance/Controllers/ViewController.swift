//
//  ViewController.swift
//  MyLeap Balance
//
//  Created by Mohsen Qaysi on 10/6/18.
//  Copyright © 2018 Mohsen Qaysi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    var viewControllerfullCardInfo: CardInfo?
    var balance = "€0.0" {
        didSet{
            balanceLabel.text = balance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        guard let card = viewControllerfullCardInfo else { return }
        balance = card.travelBalance!
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
