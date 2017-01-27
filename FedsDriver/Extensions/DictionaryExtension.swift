//
//  DictionaryExtension.swift
//  FedsDriver
//
//  Created by Alfred Thekkan on 1/21/17.
//  Copyright © 2017 Alfred. All rights reserved.
//

import Foundation

extension Dictionary {
    func flatten() -> Dictionary{
        var newDict = Dictionary()
        for (key, value) in self {
            newDict.updateValue(value, forKey: key)
            print(value)
        }
        return newDict
    }
}
