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
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

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
        let yValue = calculateYLocation(currentYLocation: currentLocation.y)
        let newLocation = CGPoint(x: currentLocation.x, y: yValue)
        if newLocation.x <= 25 || newLocation.x > UIScreen.main.bounds.size.width - 25 ||
            newLocation.y <= 25 || newLocation.y >= UIScreen.main.bounds.size.height - 25
        {
            return
        }
        self.superview!.center = newLocation
    }
    
    private func calculateYLocation(currentYLocation: CGFloat) -> CGFloat {
        let state = ViewControllerStateHelper.shared.getViewControllerState()
        let backGroundViewHeight = self.backGroundView.frame.height
        if state {
            return currentYLocation + (screenHeight - backGroundViewHeight)
        } else {
            return currentYLocation
        }
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
        let window = UIApplication.shared.windows.first
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        let superViewWidth = self.superview!.frame.size.width
        let superViewHeight = self.superview!.frame.size.height
        let leftDistance = currentPosition.x
        let rightDistance = screenWidth - leftDistance
        let topDistance = currentPosition.y - topPadding
        let bottomDistance = screenHeight - topDistance - bottomPadding

        var locationY = calculateYLocation(currentYLocation: currentPosition.y)
        if locationY.isLess(than: topPadding) {
            locationY = topPadding + (superViewHeight * 0.5)
        } else if !locationY.isLess(than: screenHeight - superViewHeight - bottomPadding) {
            locationY = screenHeight - (superViewHeight * 0.5) - bottomPadding
        }

        var locationX: CGFloat = 0
        if leftDistance > rightDistance {
            locationX = screenWidth - (superViewWidth * 0.5)
        } else {
            locationX = (superViewWidth * 0.5)
        }
        
        let miniDistance = leftDistance
        var director = CommentedButtonPosition.Left
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
                self.superview!.center = CGPoint(
                    x: locationX,
                    y: locationY)
            }
        case .Right:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(
                    x: locationX,
                    y: locationY)
            }
        case .Top:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(
                    x: locationX,
                    y: locationY)
            }
        case .Bottom:
            UIView.animate(withDuration: 0.25) {
                self.superview!.center = CGPoint(
                    x: locationX,
                    y: locationY)
            }
        }
    }
}
