//
//  Languager.swift
//  Languager
//
//  Created by Enjoy on 2018/9/25.
//

import UIKit

public protocol LanguageAdapter {
    
    func availableLanguages(_ languages: [String]) -> [String]
    
    func adapt(_ language: String, default displayName: String) -> String?
}

extension LanguageAdapter {
    
    public func availableLanguages(_ languages: [String]) -> [String] {
        return languages
    }
    
    public func adapt(_ language: String, default displayName: String) -> String? {
        return displayName
    }
}

open class Languager {
    
    public static let shared = Languager()
    
    internal var currentBundle:Bundle?
    
    public var adapter: LanguageAdapter?
    
    open var defaultLanguage: String = "en"
    
    public init() {
        print("Hello0 worl")
    }
    
    public var systemPreferredLanguage: String {
        guard let current = NSLocale.current.languageCode else { return "" }
        
        if !self.availableLanguages().contains(current) {
            return ""
        }
        return current
    }
    
    private var userSettingLanguage: String {
        get {
            guard let langauge =  UserDefaults.language.string(for: .userSettingLanguage) else {
                return ""
            }
            return langauge
        }
        set {
            UserDefaults.language.set(newValue, for: .userSettingLanguage)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var _currentLanguage: String = ""
    
    public var currentLanguage: String {
        get {
            return _currentLanguage
        }
        set {
            guard newValue != _currentLanguage else { return }
            
            guard let path = Bundle.main.path(forResource: newValue, ofType: "lproj"), let bundle = Bundle(path:path) else { return }
            
            _currentLanguage = newValue
            userSettingLanguage = newValue
            currentBundle = bundle
            Bundle.main.onLanguage()
            NotificationCenter.default.post(name: NSNotification.Name.Langauge.DidChange, object: newValue)
        }
    }
    
    public func initialize() {
        
        if userSettingLanguage.isEmpty == false {
            currentLanguage = userSettingLanguage
        } else if systemPreferredLanguage.isEmpty == false {
            currentLanguage = systemPreferredLanguage
        } else {
            currentLanguage = self.defaultLanguage
        }
    }
    
    public func reset() {
        userSettingLanguage = ""
        currentLanguage = self.defaultLanguage
    }
    
    
    public func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        
        if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        
        if let adapterLanguages = self.adapter?.availableLanguages(availableLanguages) {
            availableLanguages = adapterLanguages
        }
        return availableLanguages
    }
    
    public func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: language)
        
        guard let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) else {
            return String()
        }
        
        if let name = self.adapter?.adapt(language, default: displayName), !name.isEmpty {
            return name
        }
        return displayName
    }
    
}
