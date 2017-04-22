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

final class FDTextFieldTableViewCell: Cell<String>, CellType, UITextFieldDelegate{
    
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
        textField.text = row.value
        textField.placeholder = row.placeHolder
        textField.isSecureTextEntry = row.isSecureTextEntry
        textField.delegate = self
        super.update()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let row = self.row as? FDTextRow else {
            return true
        }
        row.value = textField.text != nil ? textField.text! + string : ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let row = self.row as? FDTextRow else {
            return
        }
        row.value = textField.text != nil ? textField.text : ""
    }
}



final class FDTextRow: Row<FDTextFieldTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<FDTextFieldTableViewCell>(nibName: FDTextFieldTableViewCell.identifier)
    }
    var placeHolder: String?
    var isSecureTextEntry = false
}
