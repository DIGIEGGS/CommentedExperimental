//
//  CommentedView.swift
//  CommentDeneme
//
//  Created by Uğur Gedik on 8.08.2023.
//

import UIKit

enum CommentedButtonPosition {
    case Left
    case Right
    case Top
    case Bottom
}

protocol CommentedButtonProtocol {
    func commentedButtonPressed()
}

class CommentedButton: UIView {
    var backGroundView = UIView()
    var lastPosition = CGPoint()
    var delegate: CommentedButtonProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createViews()
        fatalError("init(coder:) has not been implemented")
    }

    private func createViews() {
        self.backgroundColor = UIColor.green
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.lastPosition = (touch?.location(in: self.backGroundView))!
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let currentLocation = touch.location(in: self.backGroundView)
        let yValue = ViewControllerStateHelper.shared.getViewControllerState() ? currentLocation.y + (UIScreen.main.bounds.height - self.backGroundView.frame.height) : currentLocation.y
        let newLocation = CGPoint(x: currentLocation.x, y: yValue)
        if newLocation.x <= 25 || newLocation.x > UIScreen.main.bounds.size.width - 25 ||
            newLocation.y <= 25 || newLocation.y >= UIScreen.main.bounds.size.height - 25
        {
            return
        }
        self.superview!.center = newLocation
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentLocation: CGPoint = (touch?.location(in: self.backGroundView))!
        if pow(self.lastPosition.x - currentLocation.x, 2) + pow(self.lastPosition.y - currentLocation.y, 2) < 1 {
            if let delegate = self.delegate {
                delegate.commentedButtonPressed()
            }
        }
        self.adjustPosition(CurrentPosition: currentLocation)
    }

    private func adjustPosition(CurrentPosition currentPosition: CGPoint) {
        let leftDistance = currentPosition.x
        let rightDistance = UIScreen.main.bounds.size.width - currentPosition.x
        let topDistance = currentPosition.y
        let bottomDistance = UIScreen.main.bounds.size.height - currentPosition.y

        let miniDistance = leftDistance
        var director = CommentedButtonPosition.Left
        
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        var locationY = currentPosition.y
        let mainScreenHeight = UIScreen.main.bounds.size.height
        if locationY.isLess(than: topPadding) {
              locationY = topPadding
        } else if !locationY.isLess(than: mainScreenHeight - self.superview!.frame.size.height - bottomPadding) {
            locationY = mainScreenHeight - self.superview!.frame.size.height - bottomPadding
            }
        
        if rightDistance < miniDistance {
            director = CommentedButtonPosition.Right
        } else if topDistance < miniDistance {
            director = CommentedButtonPosition.Top
        } else if bottomDistance < miniDistance {
            director = CommentedButtonPosition.Bottom
        }
        switch director {
        case .Left:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(x: self.superview!.frame.size.width * 0.5, y: locationY)
            }
        case .Right:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(x: UIScreen.main.bounds.size.width - self.superview!.frame.size.width * 0.5, y: locationY)
            }
        case .Top:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(x: currentPosition.x, y: (self.superview!.frame.size.height * 0.5) + topPadding)
            }
        case .Bottom:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(x: currentPosition.x, y: (UIScreen.main.bounds.size.height - self.superview!.frame.size.height * 0.5) - bottomPadding)
            }
        }
    }
}
