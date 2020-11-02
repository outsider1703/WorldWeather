//
//  FullTextViewController.swift
//  WorldWeather
//
//  Created by Macbook on 30.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class FullTextViewController: UIViewController {
    
    let fullTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .background
        textView.font = UIFont(name: "SFProDisplay-Regular", size: 25)
        textView.textColor = .white
        textView.canCancelContentTouches = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fullTextView)
        fullTextView.frame = view.bounds
    }

}
