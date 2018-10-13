//
//  TripTableViewCell.swift
//  MyLeap Balance
//
//  Created by Mohsen Qaysi on 10/13/18.
//  Copyright © 2018 Mohsen Qaysi. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewColor.backgroundColor = .yellow
        self.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        self.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
