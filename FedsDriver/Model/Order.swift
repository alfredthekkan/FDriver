//
//  Order.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/27/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class Order {
    var mobile          :String?
    var orderDateTime   :Date?
    var orderPk         :String?
    var orderTokenId    :String?
    var price           :Double?
    var statusName      :String?
    var userName        :String?
    var service         :Service.ServiceType = .invalid
    var payment         :Payment?
    var distance        :Double!
    var fromAddress     :DeliveryAddress{ return _addresses[0] }
    var toAddress       :DeliveryAddress?{ return _addresses.count > 1 ? _addresses[1] : nil }
    var _addresses      :[DeliveryAddress]!
    var status          :OrderStatus = .undefined
    required init?(map: Map) {}
    init() {}
    
    enum OrderStatus: String {
        case pending, started, finished, undefined
    }
}

//MARK: - Mappable conformance
extension Order: Mappable {
    func mapping(map: Map) {
        mobile          <- map["mobile"]
        orderDateTime   <- (map["order_datetime"], FDDateTransform())
        orderPk         <- map["order_pk"]
        orderTokenId    <- map["order_tokenid"]
        price           <- map["price"]
        status          <- map["status"]
        statusName      <- map["status_name"]
        userName        <- map["username"]
        service         <- map["product_name"]
        distance        <- map["distance"]
        _addresses      <- map["addresslist"]
    
    }
}

//MARK: - API Calls
extension Order  {
    @discardableResult
    class func fetch(completionHandler : @escaping ([Order]?, Error?) -> Void) -> Alamofire.Request{
        let URL = API.Url!.appendingPathComponent("getorders")
        var params:[String: Any] = ["accessToken":User.current.accessToken!]
        params += User.current.location.values()
        params += DeviceInfo.values
        print(params)
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).validate().responseArray(keyPath: "data.orders") {(response : DataResponse<[Order]>) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            completionHandler(response.result.value!, nil)
        }
    }
    
    private func start() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("takeorder")
        let params = ["accessToken": User.current.accessToken, "order_tokenid":orderTokenId, "order_pk":orderPk]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).response{ [ weak self] response in
            if let _ = response.error { return }
            self?.status = .started
        }
    }
    
    private func end() -> Alamofire.DataRequest {
        let URL = API.Url!.appendingPathComponent("endorder")
        let params = ["accessToken": User.current.accessToken, "order_tokenid":orderTokenId, "order_pk":orderPk]
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default).response{ [ weak self] response in
            if let _ = response.error { return }
            self?.status = .finished
        }
    }
    
    func action() -> Alamofire.DataRequest {
        if status == .pending {
            return start()
        }
        return end()
    }
}

class FDDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let dateString = value as? String else { return nil }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: dateString)
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        guard value != nil else { return nil }
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        return df.string(from: value!)
    }
}

extension Date {
    var toString :String {
        return FDDateTransform().transformToJSON(self)!
    }
}
