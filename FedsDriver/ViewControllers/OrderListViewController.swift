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
        navigationItem.hidesBackButton = true
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(OrderListViewController.logoutTapped(sender:)))
        navigationItem.rightBarButtonItem = logoutButton
        content = TableViewDelegate(tableview: tableView)
        content.onSelect{ [weak self] order in
            if let welf = self {
                let orderViewController = welf.storyboard!.instantiateViewController(withIdentifier: OrderViewController.identifier) as! OrderViewController
                orderViewController.orderCompletionBlock = {
                    if let index = self?.content.models?.index(of: order) {
                        self?.content.models?.remove(at: index)
                        self?.content.reload()
                    }
                }
                orderViewController.order = order
                welf.navigationController?.pushViewController(orderViewController, animated: true)
            }
            }.onCellSetup{ order, cell in
                cell.setOrder(order)
        }
        Order.fetch{ [weak self] orders, error in
            self?.content.models = orders?.filter({return $0.status != .finished})
        }
    }
    
    func logoutTapped(sender: Any?) {
        showLoader()
        User.current.logout().response { (response) in
            self.hideLoader()
            self.view.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
        }
    }
}


