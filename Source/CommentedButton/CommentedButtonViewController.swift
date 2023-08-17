//
//  CommentedButtonViewController.swift
//  CommentDeneme
//
//  Created by Uğur Gedik on 8.08.2023.
//

import UIKit

class CommentedButtonViewController: UIViewController, CommentedButtonProtocol {
    func commentedMenuOpened(location: CGPoint) {
        self.commentedWindow.frame = CGRect(x: location.x, y: location.y, width: 150, height: 50)
    }

    func commentedMenuClosed(location: CGPoint) {
        self.commentedWindow.frame = CGRect(x: location.x, y: location.y, width: 50, height: 50)
    }

    var commentedButtonCallBack: (() -> ())?

    func commentedButtonPressed() {
        if let _ = self.commentedButtonCallBack {
            self.commentedButtonCallBack!()
        }
    }

    lazy var commentedButton: CommentedButton = .init(frame: CGRect.zero)

    lazy var commentedWindow: UIWindow = {
        var tempWindow = UIWindow()
        tempWindow.windowLevel = UIWindowLevelAlert + 1
        tempWindow.frame = CGRect(x: 0, y: 100, width: 50, height: 50)
        tempWindow.backgroundColor = .blue
        return tempWindow
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect.zero
        self.commentedWindow.addSubview(self.commentedButton)

        self.commentedButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.size.equalTo(50)
        }
        self.commentedButton.delegate = self
        self.commentedWindow.makeKeyAndVisible()
    }

    func setCommentedBackGroundView(backGroundView: UIView) {
        self.commentedButton.backGroundView = backGroundView
    }
}
