//
//  User.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

import ObjectMapper
import CoreLocation
import Alamofire
import AlamofireObjectMapper
class User {
    var location : CLLocationCoordinate2D!{
        get{
            return CLLocationCoordinate2D(latitude: Double(_latitude!)!, longitude: Double(_longitude!)!)
        }set{
            _latitude = "\(newValue.latitude)"
            _longitude = "\(newValue.longitude)"
        }
    }
    fileprivate var _latitude: String?
    fileprivate var _longitude: String?
    static var current     :User!
    
    var accessToken     :String!
    var firstname       :String!
    var mobile          :String!
    var email           :String!
    
    required init?(map: Map) {}
}

//MARK: - API calls
extension User {
    class func login(_ parameters: [String: Any]) -> Alamofire.DataRequest{
        var params:[String:Any] = parameters
        params += DeviceInfo.values
        
        let URL = API.Url!.appendingPathComponent("authenticate")
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default).validateErrors().responseObject(keyPath:"data") { (response : DataResponse<User>) in
            if let _ = response.result.error { return }
            User.current = response.result.value
        }
    }
    /*
    func startOrder(order: Order){
        let URL = API.Url!.appendingPathComponent("takeorder")
        var params = ["accessToken": User.current.accessToken, "order_tokenid":order.orderTokenId, "order_pk": order.orderPk]
        SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default)
    }
    func finishOrder() {
        let URL = API.Url!.appendingPathComponent("endorder")
        var params = ["accessToken": User.current.accessToken, "order_tokenid":order.orderTokenId, "order_pk": order.orderPk]
        SessionManager.default.request(URL, method: .post, parameters: params, encoding : JSONEncoding.default)
    }*/
}

extension User: Mappable {
    func mapping(map: Map) {
        accessToken         <- map["accessToken"]
        firstname           <- map["firstname"]
        mobile              <- map["mobile"]
        email               <- map["email"]
    }
    func update(with params:Parameters){
        let map = Map(mappingType: .fromJSON, JSON: params)
        mapping(map: map)
    }
}
func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
        for (k, v) in right { left.updateValue(v, forKey: k)
    }
}

extension Alamofire.DataRequest{
    func validateErrors() -> Self {
        return validate{ _, response, data in
            
            if response.statusCode == 200 {
                return .success
            }else{
                var msg:String? = ""
                if let data = data {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        let errorDict = dict?["data"] as? [String: String]
                        msg = errorDict?["error"]
                    }catch{
                        msg = "Response is empty"
                    }
                }
                if msg == nil {
                    msg = "Response is empty"
                }
                let error = NSError(domain: msg!, code: response.statusCode, userInfo: nil)
                return .failure(error)
            }
        }.debugLog()
    }
    
    private func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
    
}
