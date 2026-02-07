//
//  EmojiUITextField.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import UIKit

final class EmojiUITextField: UITextField {

    override var textInputMode: UITextInputMode? {
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" }) ?? super.textInputMode
    }
}
