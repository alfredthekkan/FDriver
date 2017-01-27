//
//  LoginViewController.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import PromiseKit

class LoginViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
    }
    
    private func setupForm() {
        form +++ Section()
            <<< LabelRow {
                $0.value = "Username"
            }
            <<< TextRow("username") { row in
            
        }
            <<< LabelRow {
                $0.value = "Password"
            }
            <<< TextRow("password") { row in
                
        }
            <<< ButtonRow{ row in
                row.title = "Login"
                }.onCellSelection{[weak self] cell, row in
                    self?.next()
        }
    }
    
    //MARK: - User interaction
    func next() {
        let username = form.rowBy(tag: "username")!.baseValue
        let password = form.rowBy(tag: "password")!.baseValue
        var values:[String:Any] = ["username":username!, "password":password!]
        let _ = firstly {
            return CLLocationManager.promise()
            }.then{ location -> Void in
                values += location.coordinate.values()
                User.login(values).response{[weak self] response in
                    if let error = response.error {
                        print(error.localizedDescription)
                        return
                    }
                    if let id = self?.defaultStoryBoardIdentifier {
                        self?.performSegue(withIdentifier: id, sender: nil)
                    }
                }
            }.catch(execute: {error in
                print(error.localizedDescription)
            }
        )
    }
}

