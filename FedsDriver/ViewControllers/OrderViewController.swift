   //
//  OrderViewController.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/28/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import UIKit
import Eureka
import MapKit
import Alamofire

class OrderViewController: FormViewController {
  var order: Order!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    
    var orderCompletionBlock: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        addLocation()
        
        actionButton.setTitle(order.status.statusText(), for: .normal)
    }
    
    func setupForm() {
        form +++ Section()
        
            <<< LocationTitleRow {
                $0.value = order.fromAddress.address
                $0.type = .source
        }
            <<< LocationTitleRow {
                $0.value = order.toAddress?.address
                $0.type = .destination
        
        }
    }
    @IBAction func actionTapped(_ sender: UIButton) {
        sender.isEnabled = false
        showLoader()
        order.action().responseJSON {[weak self] response in
            self?.hideLoader()
            if let error = response.result.error {
                self?.show(error: error)
                return
            }
            
            self?.order.status.next()
            if self?.order.status == .finished {
                self?.orderCompletionBlock?()
                let _ = self?.navigationController?.popViewController(animated: true)
                
            }else {
                if let data = response.result.value as? [String: Any] {
                    if let dict = data["data"] as? [String: Any] {
                        if let message = dict["message"] as? String {
                            self?.showMessage(message)
                        }
                    }
                }
                sender.setTitle(self?.order.status.statusText(), for: .normal)
                sender.isEnabled = true
            }
        }
    }
    
    private func addLocation() {
        var annotations = [MKAnnotation]()
        let sourceAnnotation = MKPointAnnotation(order.fromAddress)
        annotations.append(sourceAnnotation)
        if let address = order.toAddress {
            let destinationAnnotation = MKPointAnnotation(address)
            annotations.append(destinationAnnotation)
        }
        mapView.addAnnotations(annotations)
    }
}

extension MKPointAnnotation {
    convenience init(_ address: DeliveryAddress) {
        self.init()
        title = address.address
        coordinate = address.coordinate
    }
}

extension OrderViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let view = mapView.view(for: annotation) { return view }
        return MKPinAnnotationView(annotation: annotation, reuseIdentifier: "view")
    }
}
