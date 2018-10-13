//
//  CardInfoViewController.swift
//  MyLeap Balance
//
//  Created by Mohsen Qaysi on 10/10/18.
//  Copyright © 2018 Mohsen Qaysi. All rights reserved.
//

import UIKit

class CardInfoViewController: UIViewController {

    @IBOutlet weak var autoTopup: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardStatus: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var creditStatus: UILabel!
    @IBOutlet weak var expiryData: UILabel!
    @IBOutlet weak var issueData: UILabel!
    
    var cardInfo: CardInfo?
    var str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController cardInfo:  \(str)")
        guard let card = cardInfo else { return }
        setCardDetails(card)
    }
    
    func setCardDetails(_ cardinfo: CardInfo){
        DispatchQueue.main.async {
            self.autoTopup.text = cardinfo.autoTopup!
            self.cardNumber.text = cardinfo.cardNumber!
            self.cardStatus.text = cardinfo.cardStatus!
            self.cardType.text = cardinfo.cardType!
            self.creditStatus.text = cardinfo.creditStatus!
            self.expiryData.text = cardinfo.expiryDate!
            self.issueData.text = cardinfo.issueDate!
        }
    }
}
