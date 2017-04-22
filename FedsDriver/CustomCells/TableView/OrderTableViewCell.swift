//
//  OrderTableViewCell.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/27/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var datelabel        : UILabel!
    @IBOutlet weak var sourceLabel      : UILabel!
    @IBOutlet weak var destinationLabel : UILabel!
    @IBOutlet weak var referenceLabel   : UILabel!
    
    @IBOutlet weak var destinationStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Public methods
    func setOrder(_ order: Order) {
        sourceLabel.text = order.fromAddress.address
        if let destination = order.toAddress?.address {
            destinationLabel.text = destination
        }else {
            destinationStackView.isHidden = true
        }
        datelabel.text = order.orderDateTime?.toString
        referenceLabel.text = "Ref# " + order.orderTokenId!
    }

}

extension NSObject {
    var identifier: String {
        return "test"
    }
}
