//
//  LoginViewController.swift
//  MyLeap Balance
//
//  Created by Mohsen Qaysi on 10/10/18.
//  Copyright © 2018 Mohsen Qaysi. All rights reserved.
//

import UIKit

struct Identifiers {
    static let CardInfoViewControllerSegue = "CardInfoViewControllerSegue"
    static let ViewControllerSegue = "ViewControllerSegue"
    static let cardInfoUserDefults = "cardInfoUserDefults"
    static let cellID = "cellID"
}

struct CardInfo: Decodable {
    let autoTopup, cardNumber, cardStatus, cardType: String?
    let creditStatus, expiryDate, issueDate, travelBalance: String?
    
    init(autoTopup: String? = nil, cardNumber: String? = nil, cardStatus: String? = nil, cardType: String? = nil, creditStatus: String? = nil, expiryDate: String? = nil, issueDate: String? = nil, travelBalance: String? = nil) {
        self.autoTopup = autoTopup
        self.cardNumber = cardNumber
        self.cardStatus = cardStatus
        self.cardType = cardType
        self.creditStatus = creditStatus
        self.expiryDate = expiryDate
        self.issueDate = issueDate
        self.travelBalance = travelBalance
    }
    
    enum CodingKeys: String, CodingKey {
        case autoTopup = "auto_topup"
        case cardNumber = "card_number"
        case cardStatus = "card_status"
        case cardType = "card_type"
        case creditStatus = "credit_status"
        case expiryDate = "expiry_date"
        case issueDate = "issue_date"
        case travelBalance = "travel_balance"
    }
}

class LoginViewController: UIViewController {
    @IBOutlet weak var userNmaeField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let userDefults =  UserDefaults.standard
    
    var url: String = "https://leap-card-api.herokuapp.com/login"
    
    var cardinfo = CardInfo() {
        didSet {
            print("cardinfo: \(cardinfo)")
            indicator.isHidden = true
            indicator.stopAnimating()
            // navigate to the card info view
            self.performSegue(withIdentifier: Identifiers.ViewControllerSegue , sender: self)
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(segue.destination)
//        let vc = segue.destination as? ViewController
//        vc?.str = "I was updated"
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
        if segue.identifier == Identifiers.ViewControllerSegue {
            if let nextViewController = segue.destination as? ViewController {
                print("destination: \(nextViewController)")
                nextViewController.viewControllerfullCardInfo = cardinfo
                nextViewController.userName = userNmaeField.text!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNmaeField.delegate = self
        self.passWordField.delegate = self
        indicator.isHidden = true
        //        loginButton.isEnabled = false
        //        loginButton.alpha = 0.5
    }
    
    func fecthJSON(fullURL: String) {
        guard let urlString = URL(string: fullURL) else {return}
        URLSession.shared.dataTask(with: urlString) { (jsonData, resp, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Faild to get data from server: \(error)")
                    self.indicator.stopAnimating()
                    return
                }
                guard let data = jsonData else {return}
                do {
                    let fetchedData = try! JSONDecoder().decode(CardInfo.self, from: data)
                    self.cardinfo = fetchedData
//                    print("fetchedData: \(fetchedData)")
                    
                } catch let parsingError {
                    self.indicator.stopAnimating()
                    print("Error", parsingError.localizedDescription)
                }
            }
            }.resume()
    }
    
    @IBAction func tryLoggingUser(_ sender: UIButton) {
        guard let userName = userNmaeField.text, userNmaeField.text != "" else {
            print("userName is requried")
            return
        }
        guard let passWord = passWordField.text, passWordField.text != "" else {
            print("passWord is requried")
            return
        }
        print("userName: \(userName)")
        print("passWord: \(passWord)")
        indicator.isHidden = false
        indicator.startAnimating()
        
        let fullURL = String("\(url)/\(userName)/\(passWord)")
        // https://leap-card-api.herokuapp.com/login/<userName>/<passWord>
        fecthJSON(fullURL: fullURL)
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
        let url = URL(string: "https://www.leapcard.ie/en/OnlineAccounts/CaptureUserNameForgetPassword.aspx")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNmaeField.resignFirstResponder()
        passWordField.resignFirstResponder()
        return true
    }
}
