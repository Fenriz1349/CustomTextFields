// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A customizable SwiftUI text field with built-in validation.
/// Supports email, password (with strong validation), decimal, and alphanumeric input types.
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
                isValid = defaultValidation(for: input)
            }
        }
    }

    private func defaultValidation(for input: String) -> Bool {
        switch type {
        case .email:
            return Validators.isValidEmail(input)
        case .password:
            return Validators.isStrongPassword(input)
        case .decimal:
            return Double(input) != nil
        default:
            return !input.isEmpty
        }
    }
}
