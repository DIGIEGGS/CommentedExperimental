//
//  ViewController.swift
//  CommentedExperimental
//
//  Created by 81802412 on 08/09/2023.
//  Copyright (c) 2023 81802412. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var secondVCButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        view.addSubview(secondVCButton)
        layout()
    }
    
    @objc private func didTapButton() {
        let secondVC = SecondViewController()
        present(secondVC, animated: true)
    }

    func layout() {
        secondVCButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(100)
        }
    }
}

