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
import SwiftLoader

class LoginViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        setupForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupForm() {
        form +++ Section()
            <<< FDTextRow("username") {
                $0.placeHolder = "username"
            }
            
            <<< FDTextRow("password") {
                $0.placeHolder = "password"
                $0.isSecureTextEntry = true
            }
            
            <<< FDButtonRow { [weak self] in
                $0.action = { self?.next() }
                $0.value = "Login"
            }
    }
    
    //MARK: - User interaction
    func next() {
        if !form.validate().isEmpty { return }
        var values = form.values().flatten()
        let _ = firstly {
            return CLLocationManager.promise()
            }.then{ location -> Void in
                values += location.coordinate.values()
                User.login(values).response{[weak self] response in
                    if let error = response.error {
                        self?.show(error: error)
                        return
                    }
                    User.current.location = location.coordinate
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

protocol AlertShowable {
    func show(error: Error);
}

extension UIViewController: AlertShowable {
    func show(error: Error) {
        let message = (error as NSError).domain
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
