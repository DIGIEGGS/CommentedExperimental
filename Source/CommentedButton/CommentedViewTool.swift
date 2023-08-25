//
//  CommentedViewTool.swift
//  CommentDeneme
//
//  Created by Uğur Gedik on 8.08.2023.
//

import UIKit

class CommentedViewTool: NSObject {
    static let sharedTool = CommentedViewTool()
    override private init() {}

    override func copy() -> Any {
        return self
    }

    override func mutableCopy() -> Any {
        return self
    }

    lazy var commentedButtonVC: CommentedButtonViewController = .init()

    func createCommentedView(parent target: UIViewController, pressedCallBack callBackHandle: @escaping () -> Void) {
        target.addChildViewController(self.commentedButtonVC)
        target.view.addSubview(self.commentedButtonVC.view)
        self.commentedButtonVC.setCommentedBackGroundView(backGroundView: target.view)
        self.commentedButtonVC.commentedButtonCallBack = {
            callBackHandle()
        }
    }

    func hideCommentedButton() {
        self.commentedButtonVC.hideCommentedWindow()
    }

    func showCommentedButton() {
        self.commentedButtonVC.showCommentedWindow()
    }
}
