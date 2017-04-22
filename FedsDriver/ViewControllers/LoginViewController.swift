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
                $0.value = ProcessInfo.processInfo.environment["username"]
            }
            
            <<< FDTextRow("password") {
                $0.placeHolder = "password"
                $0.value = ProcessInfo.processInfo.environment["password"]
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
                self.showLoader()
                values += location.coordinate.values()
                User.login(values).response{[weak self] response in
                    if let error = response.error {
                        self?.hideLoader()
                        self?.show(error: error)
                        return
                    }
                    User.current.location = location.coordinate
                    if let id = self?.defaultStoryBoardIdentifier {
                        self?.performSegue(withIdentifier: id, sender: nil)
                    }
                }
            }.catch(execute: {error in
                self.show(error: error)
            }
        )
    }
}

protocol AlertShowable {
    func show(error: Error);
    func showMessage(_ message: String);
}

extension UIViewController: AlertShowable {
    func show(error: Error) {
        let message = (error as NSError).domain
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showLoader() {
        let bLayer = CALayer()
        
        let tag = 32324
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        let frame = CGRect(x: 0, y: 0, width: activityIndicator.bounds.maxX * 2, height: activityIndicator.bounds.maxY * 2)
        bLayer.frame = frame
        bLayer.backgroundColor = UIColor.black.cgColor
        bLayer.position = activityIndicator.layer.position
        activityIndicator.layer.insertSublayer(bLayer, at: 0)
        bLayer.cornerRadius = 5.0
        
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.tag = tag
        activityIndicator.startAnimating()
    }
    func hideLoader() {
        let tag = 32324
        if let activityIndcator = view.subviews.filter({ $0.tag == tag }).first as? UIActivityIndicatorView {
            activityIndcator.stopAnimating()
            activityIndcator.removeFromSuperview()
        }
    }
}
