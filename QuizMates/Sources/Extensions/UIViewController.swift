//
//  UIViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

extension UIViewController {

    private static var observerKey: UInt8 = 0

    // Binding the observer to controller's lifecycle
    func onDeinit(_ closure: @escaping () -> Void) {
        objc_setAssociatedObject(
            self,
            &UIViewController.observerKey,
            DeinitObserver(identifier: "\(type(of: self))", onDeinit: closure),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
