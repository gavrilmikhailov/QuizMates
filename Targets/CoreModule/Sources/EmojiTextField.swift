//
//  EmojiTextField.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

public struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    public func makeUIView(context: Context) -> EmojiUITextField {
        let textField = EmojiUITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.secondaryLabel]
        )
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 50)
        return textField
    }

    public func updateUIView(_ uiView: EmojiUITextField, context: Context) {
        uiView.text = text
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(_ parent: EmojiTextField) {
            self.parent = parent
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            if let text = textField.text, text.count > 1 {
                textField.text = String(text.suffix(1))
            }
            parent.text = textField.text ?? ""
        }
    }
}
