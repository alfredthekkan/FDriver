//
//  ServiceTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import ACFloatingTextfield_Swift

final class FDTextFieldTableViewCell: Cell<String>, CellType{
    
    @IBOutlet weak var textField: ACFloatingTextfield!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
       super.setup()
        self.height = { 100 }
    }

    override func update() {
        super.update()
        guard let row = self.row as? FDTextRow else { return }
        textField.text = row.text
        textField.placeholder = row.placeHolder
        textField.isSecureTextEntry = row.isSecureTextEntry
        super.update()
    }
}

extension FDTextFieldTableViewCell: UITextFieldDelegate {
    
}

final class FDTextRow: Row<FDTextFieldTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<FDTextFieldTableViewCell>(nibName: FDTextFieldTableViewCell.identifier)
    }
    var placeHolder: String?
    var text: String?
    var isSecureTextEntry = false
    
    override var value : String? {
        get {
            return cell.textField.text
        }set{
            self.value = newValue
        }
    }
}
