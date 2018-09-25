//
//  UserDefault.swift
//  Languager
//
//  Created by Enjoy on 2018/9/25.
//

import Foundation

protocol KeyNameSpaceable {}

extension KeyNameSpaceable {
    static func nameSpace<T>(_ key: T) -> String where T: RawRepresentable {
        return "\(type(of: Self.self)).\(key.rawValue)"
    }
}

protocol StringUserDefaultable: KeyNameSpaceable {
    associatedtype StringDefaultKey: RawRepresentable
}

extension StringUserDefaultable where StringDefaultKey.RawValue == String {
    
    static func set(_ value: String?, for key: StringDefaultKey) {
        let key = nameSpace(key)
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func string(for key: StringDefaultKey) -> String? {
        let key = nameSpace(key)
        return UserDefaults.standard.string(forKey: key)    }
    
}


extension UserDefaults {
    struct language: StringUserDefaultable {
        enum StringDefaultKey: String {
            case userSettingLanguage
        }
    }
}
