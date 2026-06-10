//
//  TextFieldType.swift
//  CustomTextFields
//
//  Created by Fenriz1349 on 22/08/2025.
//

import SwiftUI

public struct TextFieldConfig {
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let disableAutocorrection: Bool
    let autocapitalization: TextInputAutocapitalization
    let textContentType: UITextContentType?
}

public enum TextFieldType {
    case email
    case password
    case decimal
    case alphaNumber
    case lettersOnly
    case number

    var config: TextFieldConfig {
        switch self {
        case .email:
            return TextFieldConfig(
                keyboardType: .emailAddress,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .never,
                textContentType: .emailAddress
            )
        case .password:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: true,
                disableAutocorrection: true,
                autocapitalization: .never,
                textContentType: .password
            )
        case .decimal:
            return TextFieldConfig(
                keyboardType: .decimalPad,
                isSecure: false,
                disableAutocorrection: false,
                autocapitalization: .sentences,
                textContentType: nil
            )
        case .alphaNumber:
            return TextFieldConfig(
                keyboardType: .asciiCapable,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .words,
                textContentType: nil
            )
        case .lettersOnly:
            return TextFieldConfig(
                keyboardType: .default,
                isSecure: false,
                disableAutocorrection: false,
                autocapitalization: .words,
                textContentType: nil
            )
        case .number:
            return TextFieldConfig(
                keyboardType: .numberPad,
                isSecure: false,
                disableAutocorrection: true,
                autocapitalization: .never,
                textContentType: nil
            )
        }
    }
}
