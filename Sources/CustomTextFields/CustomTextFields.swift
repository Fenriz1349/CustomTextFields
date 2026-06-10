// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A customizable SwiftUI text field with built-in validation and flexible color scheme.
/// Supports email, password, decimal, and alphanumeric input types with custom validation.
public struct CustomTextField: View {
    // MARK: - Public Properties
    /// Optional header text displayed above the text field
    public var header: String?
    /// Placeholder text shown when the field is empty
    public let placeholder: String
    /// The text binding for this field
    @Binding public var text: String
    /// The type of text field (email, password, etc.)
    public let type: TextFieldType
    /// Optional custom validation closure
    public var validator: ((String) -> Bool)?
    /// Error message displayed when validation fails
    public var errorMessage: String?

    // Validation configuration
    /// The current validation state of this field
    @Binding public var validationState: ValidationState
    /// Color scheme for validation states
    public let colors: ValidationColors
    /// Whether errors are shown only after user interaction
    public let showErrorOnlyWhenTriggered: Bool

    // MARK: - Private State
    @State private var isValid: Bool = true
    @State private var isTriggered: Bool = false
    @FocusState private var isFocused: Bool

    // MARK: - Initializer
    /// Initializes a CustomTextField with full configuration options.
    /// - Parameters:
    ///   - header: Optional header text displayed above the field
    ///   - placeholder: Placeholder text shown when field is empty
    ///   - text: Binding to the text value
    ///   - type: Type of text field (email, password, decimal, etc.)
    ///   - validator: Optional custom validation closure; uses type-based validation if nil
    ///   - errorMessage: Error message displayed when validation fails
    ///   - validationState: Binding to control validation state externally
    ///   - colors: Color scheme for validation states (default: gray/green/red/blue)
    ///   - showErrorOnlyWhenTriggered: If true, errors shown only after user interaction
    public init(
        header: String? = nil,
        placeholder: String,
        text: Binding<String>,
        type: TextFieldType,
        validator: ((String) -> Bool)? = nil,
        errorMessage: String? = nil,
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
    /// Renders optional header text above the text field.
    @ViewBuilder
    private var headerView: some View {
        if let header = header {
            Text(header)
                .font(.headline)
        }
    }

    /// Builds the styled text input field with validation state styling and keyboard configuration.
    /// - Parameter config: Configuration containing keyboard type and security settings
    /// - Returns: A styled Group containing TextField or SecureField with modifiers
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
        .onChange(of: text) { _, newValue in
            validateInput(newValue)
        }
        .onChange(of: isFocused) { _, focused in
            if !focused {
                isTriggered = true
            }
            updateValidationState()
        }
    }

    /// Renders error message text when validation fails and conditions are met.
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
    /// Determines the border color based on focus state and validation state.
    /// - Returns: Focused color if field is focused, validation color otherwise (50% opacity for neutral)
    private var borderColor: Color {
        if isFocused {
            return colors.focused
        }

        return colors.color(for: validationState).opacity(validationState == .neutral ? 0.5 : 1.0)
    }

    /// Determines whether to display the error message based on validation mode and state.
    /// - Returns: True if field is invalid (triggered or immediate mode); false otherwise
    private var shouldShowError: Bool {
        if showErrorOnlyWhenTriggered {
            return validationState == .invalid
        } else {
            return !isValid
        }
    }

    // MARK: - Private Methods
    /// Validates input and updates validation state with animation.
    /// - Parameter input: The text to validate
    private func validateInput(_ input: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isValid = performValidation(for: input)
            updateValidationState()
        }
    }

    /// Performs validation using custom validator or type-specific default rules.
    /// - Parameter input: The text to validate
    /// - Returns: True if valid, false otherwise
    private func performValidation(for input: String) -> Bool {
        if let customValidator = validator {
            return customValidator(input)
        }
        return defaultValidation(for: input)
    }

    /// Updates the validation state based on focus, trigger status, and validation result.
    /// Prioritizes: focused → untouched → invalid → valid → neutral
    private func updateValidationState() {
        isValid = performValidation(for: text)

        if isFocused {
            validationState = .focused
        } else if !isTriggered {
            validationState = .neutral
        } else if isValid {
            validationState = .valid
        } else {
            validationState = .invalid
        }
    }

    /// Applies type-specific default validation rules (email format, password strength, etc.).
    /// - Parameter input: The text to validate
    /// - Returns: True if input matches type requirements, false otherwise
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
