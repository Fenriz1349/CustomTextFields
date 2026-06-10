//
//  TextFieldType.swift
//  CustomTextFields
//
//  Created by Fenriz1349 on 22/08/2025.
//

import SwiftUI

/// Configuration for a text field's keyboard, security, and content type settings.
/// - Properties:
///   - keyboardType: The on-screen keyboard type (email, numeric, default, etc.)
///   - isSecure: Whether the field hides character input (SecureField vs TextField)
///   - disableAutocorrection: Whether to disable spell checking and autocorrection
///   - autocapitalization: Text capitalization behavior (sentences, words, etc.)
public struct TextFieldConfig {
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let disableAutocorrection: Bool
    let autocapitalization: TextInputAutocapitalization
}

/// Predefined text field input types with type-specific configuration and validation.
/// - email: Email format validation, email keyboard, no autocorrection
/// - password: Strong password validation, secure entry, no autocorrection
/// - decimal: Numeric validation, decimal pad keyboard
/// - alphaNumber: Alphanumeric validation, ASCII keyboard
/// - lettersOnly: Letter-only validation, supports spaces and hyphens
/// - number: Integer validation, number pad keyboard
public enum TextFieldType {
    case email
    case password
    case decimal
    case alphaNumber
    case lettersOnly
    case number

    /// Returns the configuration for this field type (keyboard, security, etc.)
    var config: TextFieldConfig {
        switch self {
        case .email:
            return TextFieldConfig(
                keyboardType: .emailAddress,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .never
            )
        case .password:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: true,
                disableAutocorrection: true,
                autocapitalization: .never
            )
        case .decimal:
            return TextFieldConfig(
                keyboardType: .decimalPad,
                isSecure: false,
                disableAutocorrection: false,
                autocapitalization: .sentences
            )
        case .alphaNumber:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .words
            )
        case .lettersOnly:
            return TextFieldConfig(
                keyboardType: .default,
                isSecure: false,
                disableAutocorrection: false,
                autocapitalization: .words
            )
        case .number:
            return TextFieldConfig(
                keyboardType: .numberPad,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .never
            )
        }
    }
}
