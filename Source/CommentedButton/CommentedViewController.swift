//
//  CommentedViewController.swift
//  CommentDeneme_Example
//
//  Created by Uğur Gedik on 8.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SnapKit
import UIKit

class CommentedViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("X", for: .normal)
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return button
    }()
    
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        self.view.addSubview(imageView)
        self.view.addSubview(closeButton)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(80)
        }
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
        }
    }
}
