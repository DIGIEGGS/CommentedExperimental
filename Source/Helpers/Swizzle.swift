//
//  Swizzle.swift
//  CommentDeneme_Example
//
//  Created by Uğur Gedik on 4.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

private func swizzle(_ viewController: UIViewController.Type) {
    let swizzlers = [
        (#selector(viewController.viewDidAppear(_:)),
         #selector(viewController.devCheck_viewDidAppear(_:))),
        (#selector(viewController.viewDidDisappear(_:)),
         #selector(viewController.devCheck_viewDidDisappear(_:)))
    ]

    for (original, swizzled) in swizzlers {
        guard let originalMethod = class_getInstanceMethod(viewController, original),
              let swizzledMethod = class_getInstanceMethod(viewController, swizzled) else { continue }

        let didAddMethod = class_addMethod(viewController, original, method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(viewController, swizzled, method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

private var hasSwizzled = false
private var commentedParents: [UIViewController] = []

private func openCommentedViewControllerWithImage(completion: (UIImage?) -> ()) {
    let parent = commentedParents.last
    let image = parent?.view.takeScreenshot()
    completion(image)
}

private func openCommentedViewController(image: UIImage?) {
    let parent = commentedParents.last
    let vc = CommentedViewController(image: image)
    vc.modalPresentationStyle = .fullScreen
    parent?.present(vc, animated: true)
}

private let appName: String = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String)!

private func addToCommentedParent(parent: UIViewController) {
    if parent.debugDescription.contains(appName) || parent.debugDescription.contains("UINavigationController") {
        commentedParents.append(parent)
    }
}

private func removeFromCommentedParent(parent: UIViewController) {
    if let index = commentedParents.firstIndex(of: parent) {
        commentedParents.remove(at: index)
    }
}

extension UIViewController {
    var commentedExperimental: CommentedExperimental {
        return CommentedExperimental()
    }

    var isPresented: Bool {
        if let nav = self.navigationController, nav.viewControllers.isEmpty || self == nav.viewControllers.first {
            return false
        }
        if self.presentingViewController != nil {
            return true
        }
        if let nav = self.navigationController, nav.presentingViewController?.presentedViewController == nav {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }

    public final class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self)
    }

    @objc internal func devCheck_viewDidAppear(_ animated: Bool) {
        self.devCheck_viewDidAppear(animated)
        ViewControllerStateHelper.shared.setViewControllerState(isPresented: self.isPresented)
        let isNotCommentedButtonVC = !(self is CommentedButtonViewController)
        if isNotCommentedButtonVC {
            addToCommentedParent(parent: self)
            let commentedViewTool = CommentedViewTool.sharedTool
            commentedViewTool.createCommentedView(parent: self) {
                openCommentedViewControllerWithImage() { image in
                    openCommentedViewController(image: image)
                }
            }
        }
    }

    @objc internal func devCheck_viewDidDisappear(_ animated: Bool) {
        self.devCheck_viewDidDisappear(animated)
        let isNotCommentedButtonVC = !(self is CommentedButtonViewController)
        let isNotCommentedVC = !(self is CommentedViewController)
        if isNotCommentedVC && isNotCommentedButtonVC {
            ViewControllerStateHelper.shared.setViewControllerState(isPresented: false)
            removeFromCommentedParent(parent: self)
        }
    }
}

extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if image != nil {
            return image!
        }
        return UIImage()
    }
}
