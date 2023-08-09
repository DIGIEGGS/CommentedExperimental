//
//  SecondViewController.swift
//  CommentedExperimental_Example
//
//  Created by Semih Güler on 9.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        button.backgroundColor = .brown
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.backgroundColor = .darkGray
        backButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}
