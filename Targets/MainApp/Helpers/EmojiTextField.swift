//
//  EmojiTextField.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    func makeUIView(context: Context) -> EmojiUITextField {
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

    func updateUIView(_ uiView: EmojiUITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(_ parent: EmojiTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let text = textField.text, text.count > 1 {
                textField.text = String(text.suffix(1))
            }
            parent.text = textField.text ?? ""
        }
    }
}
