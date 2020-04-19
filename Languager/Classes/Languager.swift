//
//  Languager.swift
//  Languager
//
//  Created by rsenjoyer on 2018/9/25.
//

import UIKit

open class Languager {
    
    public static let shared = Languager()
    
    public var currentBundle: Bundle?
    
    public var adapter: LanguageAdapter?
    
    private init() {}
    
    private var systemPreferredLanguage: String? {
        guard let current = NSLocale.current.languageCode, !self.availableLanguages().contains(current) else { return nil }
        return current
    }
    
    private var userSettingLanguage: String? {
        get {
            guard let language = UserDefaults.language.string(for: .userSettingLanguage) else {
                return nil
            }
            return language
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
            guard newValue != _currentLanguage, self.availableLanguages().contains(newValue) else {
                return
            }
            
            guard let path = Bundle.main.path(forResource: newValue, ofType: "lproj"), let bundle = Bundle(path: path) else {
                return
            }
            
            _currentLanguage = newValue
            userSettingLanguage = newValue
            currentBundle = bundle
            NotificationCenter.default.post(name: NSNotification.Name.Langauge.DidChange, object: newValue)
        }
    }
    
    public func set(adapter: LanguageAdapter) {
        self.adapter = adapter
    }
    
    @discardableResult
    public func initialize() -> Languager {
        if currentLanguage.isEmpty, let userSettingLanguage = userSettingLanguage {
            currentLanguage = userSettingLanguage
        }
        
        if currentLanguage.isEmpty, let systemPreferredLanguage = systemPreferredLanguage {
            currentLanguage = systemPreferredLanguage
        }
        
        if currentLanguage.isEmpty, let defaultLanguage = self.adapter?.defaultLanguage {
            currentLanguage = defaultLanguage
        }
        
        if currentLanguage.isEmpty, let first = self.availableLanguages(excludeBase: true).first {
            currentLanguage = first
        }
        
        if (currentLanguage.isEmpty) {
            currentLanguage = "Base"
        }
        
        Bundle.onLanguage()
        
        return self
    }
    
    public func availableLanguages(excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        
        if let adapterLanguages = self.adapter?.availableLanguages(availableLanguages) {
            availableLanguages = adapterLanguages
        }
        print(availableLanguages)
        return availableLanguages
    }
    
    public func displayName(forLanguage language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: language)
        
        guard let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) else {
            return String()
        }
        
        if let name = self.adapter?.displayName(for: language, defaultName: displayName), !name.isEmpty {
            return name
        }
        return displayName
    }
}
