//
//  ViewControllerStateHelper.swift
//  CommentedExperimental
//
//  Created by Semih Güler on 9.08.2023.
//

import Foundation

class ViewControllerStateHelper {

    static let shared = ViewControllerStateHelper()
    
    private init() {
        UIViewController.swizzleDismiss()
    }
    
    private let defaults = UserDefaults.standard
    private let viewControllerPresentedKey = "ViewControllerIsPresentedKey"
    
    func setViewControllerState(isPresented: Bool) {
        defaults.set(isPresented, forKey: viewControllerPresentedKey)
    }
    
    func getViewControllerState() -> Bool {
        return defaults.bool(forKey: viewControllerPresentedKey)
    }
}
