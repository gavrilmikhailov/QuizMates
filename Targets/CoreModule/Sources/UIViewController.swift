//
//  UIViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

public extension UIViewController {

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

private final class DeinitObserver {
    private let identifier: String
    private let onDeinit: () -> Void

    init(identifier: String, onDeinit: @escaping () -> Void) {
        self.identifier = identifier
        self.onDeinit = onDeinit
        print("🐣 [Memory] Allocated: \(identifier)")
    }

    deinit {
        print("🗑️ [Memory] Deallocated: \(identifier)")
        onDeinit()
    }
}
