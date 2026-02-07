//
//  DeinitObserver.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

final class DeinitObserver {
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
