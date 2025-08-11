// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct TextFieldConfig {
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let disableAutocorrection: Bool
    let autocapitalization: TextInputAutocapitalization
}

public enum TextFieldType {
    case email
    case password
    case decimal
    case alphaNumber

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
        }
    }
}

public struct CustomTextField: View {
    public var header: String?
    public let placeholder: String
    @Binding public var text: String
    public let type: TextFieldType
    public var validator: ((String) -> Bool)?
    public var errorMessage: String?

    @State private var isValid: Bool = true

    public init(
        header: String? = nil,
        placeholder: String,
        text: Binding<String>,
        type: TextFieldType,
        validator: ((String) -> Bool)? = nil,
        errorMessage: String? = nil
    ) {
        self.header = header
        self.placeholder = placeholder
        self._text = text
        self.type = type
        self.validator = validator
        self.errorMessage = errorMessage
    }

    public var body: some View {
        let config = type.config

        VStack(alignment: .leading, spacing: 5) {
            if let header = header {
                Text(header)
                    .font(.headline)
            }

            Group {
                if config.isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor.opacity(0.3), lineWidth: 2)
            )
            .cornerRadius(8)
            .shadow(color: .primary.opacity(0.3), radius: 4, x: 1, y: 2)
            .keyboardType(config.keyboardType)
            .autocorrectionDisabled(config.disableAutocorrection)
            .textInputAutocapitalization(config.autocapitalization)
            .onChange(of: text) { newValue in
                validateInput(newValue)
            }

            if !isValid, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }

    private var borderColor: Color {
        if text.isEmpty {
            return Color.gray
        }
        return isValid ? Color.green : Color.red
    }

    private func validateInput(_ input: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let validator = validator {
                isValid = validator(input)
            } else {
                // Validation par défaut selon le type
                isValid = defaultValidation(for: input)
            }
        }
    }

    private func defaultValidation(for input: String) -> Bool {
        switch type {
        case .email:
            return isValidEmail(input)
        case .password:
            return input.count >= 6
        case .decimal:
            return Double(input) != nil
        default:
            return !input.isEmpty
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
