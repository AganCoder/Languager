//
//  NSBundle+Languager.swift
//  Languager
//
//  Created by rsenjoyer on 2018/9/25.
//

import Foundation

public class BundleEx: Bundle {
    
    override public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.languageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {
    
    internal static func onLanguage() {
        object_setClass(Bundle.main, BundleEx.self)
    }
    
    internal static func languageBundle() -> Bundle? {
        return Languager.shared.currentBundle
    }
}
