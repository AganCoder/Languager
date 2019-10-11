//
//  ViewController.swift
//  Languager
//
//  Created by gaoxiang on 09/25/2018.
//  Copyright (c) 2018 gaoxiang. All rights reserved.
//

import UIKit
import Languager

class ViewController: UIViewController {

    @IBOutlet weak var languageBtn: UIButton!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(forName: NSNotification.Name.Langauge.DidChange, object: nil, queue: .main) {_ in
            self.setupUI()
        }
    }

    @IBAction func languageBtnDidTapped(_ sender: Any) {
        
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let languages = Languager.shared.availableLanguages(excludeBase: true)
        
        languages.forEach { (lan) in
            let action = UIAlertAction(title: Languager.shared.displayName(forLanguage: lan), style: UIAlertAction.Style.default, handler: { (action) in
                Languager.shared.currentLanguage = lan
            })
            
            alter.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localizable(from: "Common"), style: .cancel, handler: nil)
        alter.addAction(cancel)
        
        present(alter, animated: true, completion: nil)
    }

    private func setupUI() {
        self.languageLabel.text = "Language".localizable()
        self.languageBtn.setTitle("Click Me".localizable(), for: .normal)
    }
}


extension String {
    
    public func localizable(from table: String = "Common") -> String {
        guard let string = Languager.shared.currentBundle?.localizedString(forKey: self, value: nil, table: table) else {
            return self
        }
        return string
    }
}

extension NSString {
    
    public func localizableFromTable(table: String) -> NSString {
        return (self as String).localizable(from: table) as NSString
    }
}
