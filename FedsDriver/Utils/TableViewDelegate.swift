//
//  TableViewDelegate.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/27/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import UIKit

class TableViewDelegate<Model: Equatable, Cell: UITableViewCell>: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    typealias ModelBlock = (_ model: Model) -> ()
    typealias ModelCellBlock = (_ model: Model,_ cell: Cell) -> ()
    
    private var tableView: UITableView!
    var models: [Model]?{
        didSet {
            tableView.reloadData()
        }
    }
    
    private var onSelect:ModelBlock?
    private var onCellSetup: ModelCellBlock?
    
    
    func reload() {
        tableView.reloadData()
    }
    
    init(tableview: UITableView) {
        super.init()
        self.tableView = tableview
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: Cell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Cell.identifier)
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 50
    }
    @discardableResult
    func onSelect(completionHandler: @escaping ModelBlock) -> Self{
        onSelect = completionHandler
        return self
    }
    @discardableResult
    func onCellSetup(completionHandler: @escaping ModelCellBlock) -> Self{
        onCellSetup = completionHandler
        return self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as! Cell
        onCellSetup?( model!, cell)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect?(model)
    }
   
   
}


extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
