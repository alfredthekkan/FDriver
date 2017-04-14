//
//  ServiceTableViewCell.swift
//  feds
//
//  Created by Alfred Thekkan on 1/15/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka

final class FDButtonTableViewCell: Cell<String>, CellType{
    
    @IBOutlet weak var button: FDButton!
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update() {
        guard let row = row as? FDButtonRow else { return }
        button.setTitle(row.value?.uppercased(), for: .normal)
        super.update()
    }
    @IBAction func buttonTapped(_ sender: Any) {
        guard let row = self.row as? FDButtonRow else { return }
        row.action?()
    }
}

final class FDButtonRow: Row<FDButtonTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<FDButtonTableViewCell>(nibName: FDButtonTableViewCell.identifier)
    }
    var action: (() -> ())?
}
