//
//  UIViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

private var observerKey: UInt8 = 0

extension UIViewController {

    // Binding the observer to controller's lifecycle
    func onDeinit(_ closure: @escaping () -> Void) {
        objc_setAssociatedObject(
            self,
            &observerKey,
            DeinitObserver(identifier: "\(type(of: self))", onDeinit: closure),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
