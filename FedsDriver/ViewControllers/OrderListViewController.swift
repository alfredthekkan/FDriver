 //
//  OrderListViewController.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/27/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {
    
    var content: TableViewDelegate<Order, OrderTableViewCell>!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        content = TableViewDelegate(tableview: tableView)
        content.onSelect{ [weak self] order in
            if let welf = self {
                let orderViewController = welf.storyboard!.instantiateViewController(withIdentifier: OrderViewController.identifier) as! OrderViewController
                orderViewController.order = order
                welf.navigationController?.pushViewController(orderViewController, animated: true)
            }
            }.onCellSetup{ order, cell in
                cell.setOrder(order)
        }
        Order.fetch{ [weak self] orders, error in
            self?.content.models = orders
        }
    }
}


