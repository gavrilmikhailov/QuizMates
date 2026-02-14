//
//  UIDebouncer.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

@MainActor
final public class UIDebouncer {

    private var task: Task<Void, Never>?
    private let duration: Duration

    public init(duration: Duration) {
        self.duration = duration
    }

    public func submit(action: @escaping @MainActor () -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: duration)
            if !Task.isCancelled {
                action()
            }
        }
    }
}
