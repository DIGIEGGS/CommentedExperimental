//
//  CommentedView.swift
//  CommentDeneme
//
//  Created by Uğur Gedik on 8.08.2023.
//

import UIKit

enum CommentedButtonMenuDirection {
    case Left
    case Right
}

protocol CommentedButtonProtocol {
    func commentedButtonPressed()
    func commentedMenuOpened(location: CGPoint)
    func commentedMenuClosed(location: CGPoint)
}

class CommentedButton: UIView {
    var backGroundView = UIView()
    var lastPosition = CGPoint()
    var delegate: CommentedButtonProtocol?

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    private var isMenuOpen = false
    private var buttonLocation = CGPoint(x: 0, y: 100)
    private var isTouchMoving = false

    lazy var buttonView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .green
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(buttonLongPressed))
        longPressGesture.allowableMovement = 2
        longPressGesture.minimumPressDuration = 1
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(buttonPressed(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(longPressGesture)
        view.addGestureRecognizer(tapGesture)
        return view
    }()

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
        self.addSubview(self.buttonView)
        self.buttonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.backgroundColor = UIColor.green
    }

    @objc private func buttonPressed(_ sender: UIGestureRecognizer) {
        if !self.isTouchMoving {
            if self.isMenuOpen {
                self.setMenuAsClosed()
                self.adjustPosition(CurrentPosition: self.lastPosition)
                self.delegate?.commentedMenuClosed(location: self.buttonLocation)
            } else {
                if let delegate = self.delegate {
                    delegate.commentedButtonPressed()
                }
            }
        } else {
            self.adjustPosition(CurrentPosition: self.lastPosition)
        }
    }

    @objc private func buttonLongPressed() {
        if !self.isMenuOpen {
            self.setMenuAsOpened()
            self.adjustPosition(CurrentPosition: self.lastPosition)
            self.delegate?.commentedMenuOpened(location: self.buttonLocation)
        }
    }

    private func setMenuAsOpened() {
        self.isMenuOpen = true
        self.buttonView.backgroundColor = .orange
    }

    private func setMenuAsClosed() {
        self.isMenuOpen = false
        self.buttonView.backgroundColor = .green
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.lastPosition = (touch?.location(in: self.backGroundView))!
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouchMoving = true
        guard let touch = touches.first else {
            return
        }
        let currentLocation = touch.location(in: self.backGroundView)
        let yValue = self.calculateYLocation(currentYLocation: currentLocation.y)
        let newLocation = CGPoint(x: currentLocation.x, y: yValue)
        let superViewHalfWidth = self.superview!.frame.size.width / 2.0
        let superViewHalfHeight = self.superview!.frame.size.height / 2.0
        if newLocation.x <= superViewHalfWidth || newLocation.x > self.screenWidth - superViewHalfWidth ||
            newLocation.y <= superViewHalfHeight || newLocation.y >= self.screenHeight - superViewHalfHeight
        {
            return
        }
        self.superview!.center = newLocation
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentLocation: CGPoint = (touch?.location(in: self.backGroundView))!
        self.adjustPosition(CurrentPosition: currentLocation)
    }

    private func calculateYLocation(currentYLocation: CGFloat) -> CGFloat {
        let state = ViewControllerStateHelper.shared.getViewControllerState()
        let backGroundViewHeight = self.backGroundView.frame.height
        if state {
            return currentYLocation + (self.screenHeight - backGroundViewHeight)
        } else {
            return currentYLocation
        }
    }

    private func adjustPosition(CurrentPosition currentPosition: CGPoint) {
        self.isTouchMoving = false
        let window = UIApplication.shared.windows.first
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        let superViewWidth = self.superview!.frame.size.width
        let superViewHeight = self.superview!.frame.size.height
        let leftDistance = currentPosition.x
        let rightDistance = self.screenWidth - leftDistance
        let topDistance = currentPosition.y - topPadding
        let bottomDistance = self.screenHeight - topDistance - bottomPadding

        var locationY = self.calculateYLocation(currentYLocation: currentPosition.y)
        if locationY.isLess(than: topPadding) {
            locationY = topPadding + (superViewHeight * 0.5)
        } else if !locationY.isLess(than: self.screenHeight - superViewHeight - bottomPadding) {
            locationY = self.screenHeight - (superViewHeight * 0.5) - bottomPadding
        }

        var locationX: CGFloat = 0
        if leftDistance > rightDistance {
            locationX = self.screenWidth - (superViewWidth * 0.5)
            self.setButtonLocationForMenuPlacement(yLocation: locationY,
                                                   menuDirection: .Left,
                                                   buttonHeight: superViewHeight,
                                                   buttonWeight: superViewWidth)
        } else {
            locationX = (superViewWidth * 0.5)
            self.setButtonLocationForMenuPlacement(yLocation: locationY,
                                                   menuDirection: .Right,
                                                   buttonHeight: superViewHeight,
                                                   buttonWeight: superViewWidth)
        }

        UIView.animate(withDuration: 0.25) {
            self.superview!.center = CGPoint(
                x: locationX,
                y: locationY)
        }
    }

    private func setButtonLocationForMenuPlacement(yLocation: CGFloat,
                                                   menuDirection: CommentedButtonMenuDirection,
                                                   buttonHeight: CGFloat,
                                                   buttonWeight: CGFloat)
    {
        var buttonYPosition: CGFloat = yLocation - (0.5 * buttonHeight)
        var buttonXPosition: CGFloat = 0
        switch menuDirection {
        case .Left:
            if self.isMenuOpen {
                buttonXPosition = self.screenWidth - 150
            } else {
                buttonXPosition = self.screenWidth - 50
            }
        case .Right:
            buttonXPosition = 0
        }
        self.buttonLocation = CGPoint(x: buttonXPosition, y: buttonYPosition)
    }
}
