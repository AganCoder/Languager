//
//  LanguageAdapter.swift
//  Languager
//
//  Created by enjoy on 2019/10/8.
//

import Foundation

public protocol LanguageAdapter {
    
    var defaultLanguage: String { get }
    
    func availableLanguages(_ languages: [String]) -> [String]
    
    func displayName(for language: String, defaultName name: String) -> String?
}

extension LanguageAdapter {
    
    public func availableLanguages(_ languages: [String]) -> [String] {
        return languages
    }
    
    public func displayName(for language: String, defaultName name: String) -> String? {
        return name
    }
    
    public var defaultLanguage: String { return "en" }
}
