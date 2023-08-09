//
//  Swizzle.swift
//  CommentDeneme_Example
//
//  Created by Uğur Gedik on 4.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

private func swizzle(_ viewController: UIViewController.Type) {
    let swizzlers = [(#selector(viewController.viewDidAppear(_:)), #selector(viewController.devCheck_viewDidAppear(_:)))]

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

private func openCommentedViewControllerWithImage(parent: UIViewController, completion: (UIImage) -> ()) {
    let image = parent.view.takeScreenshot()
    completion(image)
}

private func openCommentedViewController(parent: UIViewController, image: UIImage) {
    let vc = CommentedViewController(image: image)
    vc.modalPresentationStyle = .fullScreen
    parent.present(vc, animated: true)
}

extension UIViewController {
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
    
    public static func swizzleDismiss() {
        let originalSelector = #selector(UIViewController.dismiss(animated:completion:))
        let swizzledSelector = #selector(UIViewController.custom_dismiss(animated:completion:))
        
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)!
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc func custom_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.custom_dismiss(animated: flag, completion: completion)
        ViewControllerStateHelper.shared.setViewControllerState(isPresented: false)
    }
    
    @objc internal func devCheck_viewDidAppear(_ animated: Bool) {
        self.devCheck_viewDidAppear(animated)
        ViewControllerStateHelper.shared.setViewControllerState(isPresented: self.isPresented)
        let isAppsVC = !(self is CommentedButtonViewController)
        if isAppsVC {
            let floatView = CommentedViewTool.sharedTool
            floatView.createCommentedView(parent: self) {
                openCommentedViewControllerWithImage(parent: self) { image in
                    openCommentedViewController(parent: self, image: image)
                }
            }
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
