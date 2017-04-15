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

class OrderViewController: FormViewController {
  var order: Order!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        addLocation()
        actionButton.setTitle(order.status.rawValue, for: .normal)
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
        order.action().responseJSON {[weak self] response in
            if let error = response.result.error {
                print(error.localizedDescription)
                return
            }
            sender.setTitle(self?.order.status.rawValue, for: .normal)
            sender.isEnabled = true
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
