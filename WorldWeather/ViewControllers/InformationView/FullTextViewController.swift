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
        textView.font = UIFont.italicSystemFont(ofSize: 16)
        textView.textColor = .white
        textView.isEditable = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fullTextView)
        fullTextView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 16, left: 8, bottom: 32, right: 8))
        }
//        fullTextView.frame = view.bounds
    }

}
