//
//  CommentedButtonViewController.swift
//  CommentDeneme
//
//  Created by Uğur Gedik on 8.08.2023.
//

import UIKit

class CommentedButtonViewController: UIViewController, CommentedButtonProtocol {
    var commentedButtonCallBack: (() -> ())?

    func commentedButtonPressed() {
        if let _ = self.commentedButtonCallBack {
            self.commentedButtonCallBack!()
        }
    }

    lazy var commentedButton: CommentedButton = {
        return CommentedButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }()

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
        self.commentedButton.delegate = self
        self.commentedWindow.makeKeyAndVisible()
    }

    func setCommentedBackGroundView(backGroundView: UIView) {
        self.commentedButton.backGroundView = backGroundView
    }
}
