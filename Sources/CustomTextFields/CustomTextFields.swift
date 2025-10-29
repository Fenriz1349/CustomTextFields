// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A customizable SwiftUI text field with built-in validation and flexible color scheme.
/// Supports email, password, decimal, and alphanumeric input types with custom validation.
public struct CustomTextField: View {
    // MARK: - Public Properties
    public var header: LocalizedStringKey?
    public let placeholder: LocalizedStringKey
    @Binding public var text: String
    public let type: TextFieldType
    public var validator: ((String) -> Bool)?
    public var errorMessage: LocalizedStringKey?

    // Validation configuration
    @Binding public var validationState: ValidationState
    public let colors: ValidationColors
    public let showErrorOnlyWhenTriggered: Bool

    // MARK: - Private State
    @State private var isValid: Bool = true
    @FocusState private var isFocused: Bool

    // MARK: - Initializer
    public init(
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        type: TextFieldType,
        validator: ((String) -> Bool)? = nil,
        errorMessage: LocalizedStringKey? = nil,
        validationState: Binding<ValidationState> = .constant(.neutral),
        colors: ValidationColors = .default,
        showErrorOnlyWhenTriggered: Bool = true
    ) {
        self.header = header
        self.placeholder = placeholder
        self._text = text
        self.type = type
        self.validator = validator
        self.errorMessage = errorMessage
        self._validationState = validationState
        self.colors = colors
        self.showErrorOnlyWhenTriggered = showErrorOnlyWhenTriggered
    }

    // MARK: - Body
    public var body: some View {
        let config = type.config

        VStack(alignment: .leading, spacing: 5) {
            headerView
            
            textFieldView(config: config)
            
            errorMessageView
        }
    }

    // MARK: - View Components
    @ViewBuilder
    private var headerView: some View {
        if let header = header {
            Text(header)
                .font(.headline)
        }
    }

    private func textFieldView(config: TextFieldConfig) -> some View {
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
                .stroke(borderColor, lineWidth: 2)
        )
        .cornerRadius(8)
        .shadow(color: .primary.opacity(0.3), radius: 4, x: 1, y: 2)
        .keyboardType(config.keyboardType)
        .autocorrectionDisabled(config.disableAutocorrection)
        .textInputAutocapitalization(config.autocapitalization)
        .focused($isFocused)
        .onChange(of: text) { newValue in
            validateInput(newValue)
        }
        .onChange(of: isFocused) { focused in
            updateValidationState()
        }
    }

    @ViewBuilder
    private var errorMessageView: some View {
        if shouldShowError, let errorMessage = errorMessage {
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(colors.invalid)
                .transition(.opacity)
        }
    }

    // MARK: - Computed Properties
    private var borderColor: Color {
        if isFocused {
            return colors.focused
        }

        return colors.color(for: validationState).opacity(validationState == .neutral ? 0.5 : 1.0)
    }

    private var shouldShowError: Bool {
        if showErrorOnlyWhenTriggered {
            return validationState == .invalid && !text.isEmpty
        } else {
            return !isValid && !text.isEmpty
        }
    }

    // MARK: - Private Methods
    private func validateInput(_ input: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isValid = performValidation(for: input)
            updateValidationState()
        }
    }

    private func performValidation(for input: String) -> Bool {
        if let customValidator = validator {
            return customValidator(input)
        }
        return defaultValidation(for: input)
    }

    private func updateValidationState() {
        // Don't override invalid state if showErrorOnlyWhenTriggered is true
        if showErrorOnlyWhenTriggered && validationState == .invalid {
            return
        }

        if isFocused {
            validationState = .focused
        } else if text.isEmpty {
            validationState = .neutral
        } else if isValid {
            validationState = .valid
        } else if !showErrorOnlyWhenTriggered {
            validationState = .invalid
        } else {
            validationState = .neutral
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
        case .lettersOnly:
            return Validators.isLettersOnly(input)
        case .number:
            return Int(input) != nil
        case .alphaNumber:
            return !input.isEmpty && input.allSatisfy { $0.isLetter || $0.isNumber || $0.isWhitespace }
        }
    }
}
