//
//  NSBundle+Languager.swift
//  Languager
//
//  Created by Enjoy on 2018/9/25.
//

import Foundation

public class BundleEx: Bundle {
    
    override public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = languageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

public extension Bundle {
    
    func onLanguage() {
        object_setClass(Bundle.main, BundleEx.self)
    }
    
    func languageBundle() -> Bundle? {
        return Languager.shared.currentBundle
    }
}
