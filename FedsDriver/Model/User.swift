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
        return SessionManager.default.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseObject(keyPath:"data") { (response : DataResponse<User>) in
            if let _ = response.result.error { return }
            User.current = response.result.value
        }
    }
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
