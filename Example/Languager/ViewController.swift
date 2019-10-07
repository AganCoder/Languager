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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(forName: NSNotification.Name.Langauge.DidChange, object: nil, queue: .main) { (notify) in
            self.languageBtn.setTitle("12222222", for: .normal)
        }
    }

    @IBAction func languageBtnDidTapped(_ sender: Any) {
        let alter = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let languages = Languager.shared.availableLanguages(excludeBase: true)
        
        languages.forEach { (lan) in
            let action = UIAlertAction(title: Languager.shared.displayName(forLanguage: lan), style: UIAlertActionStyle.default, handler: { (action) in
                Languager.shared.currentLanguage = lan
                print(lan)
            })
            alter.addAction(action)
        }
        
        present(alter, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

