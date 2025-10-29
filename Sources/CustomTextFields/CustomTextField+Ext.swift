//
//  CustomTextField+Ext.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 19/09/2025.
//

import SwiftUI

// MARK: - Convenience Initializers
public extension CustomTextField {
    
    /// Creates a CustomTextField with immediate validation (shows red as soon as invalid)
    /// - Parameters:
    ///   - header: Optional header text
    ///   - placeholder: Placeholder text for the field
    ///   - text: Binding to the text value
    ///   - type: Type of text field (email, password, etc.)
    ///   - validator: Optional custom validation function
    ///   - errorMessage: Error message to display when invalid
    ///   - colors: Custom color scheme (uses default if not provided)
    /// - Returns: CustomTextField configured for immediate validation
    static func immediate(
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        type: TextFieldType,
        validator: ((String) -> Bool)? = nil,
        errorMessage: LocalizedStringKey? = nil,
        colors: ValidationColors = .default
    ) -> CustomTextField {
        return CustomTextField(
            header: header,
            placeholder: placeholder,
            text: text,
            type: type,
            validator: validator,
            errorMessage: errorMessage,
            validationState: .constant(.neutral),
            colors: colors,
            showErrorOnlyWhenTriggered: false
        )
    }
    
    /// Creates a CustomTextField with triggered validation (shows red only when manually triggered)
    /// - Parameters:
    ///   - header: Optional header text
    ///   - placeholder: Placeholder text for the field
    ///   - text: Binding to the text value
    ///   - type: Type of text field (email, password, etc.)
    ///   - validator: Optional custom validation function
    ///   - errorMessage: Error message to display when invalid
    ///   - validationState: Binding to control the validation state externally
    ///   - colors: Custom color scheme (uses default if not provided)
    /// - Returns: CustomTextField configured for triggered validation
    static func triggered(
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey,
        text: Binding<String>,
        type: TextFieldType,
        validator: ((String) -> Bool)? = nil,
        errorMessage: LocalizedStringKey? = nil,
        validationState: Binding<ValidationState>,
        colors: ValidationColors = .default
    ) -> CustomTextField {
        return CustomTextField(
            header: header,
            placeholder: placeholder,
            text: text,
            type: type,
            validator: validator,
            errorMessage: errorMessage,
            validationState: validationState,
            colors: colors,
            showErrorOnlyWhenTriggered: true
        )
    }
}

// MARK: - Validation Helpers
public extension CustomTextField {
    
    /// Manually triggers validation state to invalid (useful for form submission)
    /// - Parameter state: Binding to the validation state to update
    static func triggerError(for state: Binding<ValidationState>) {
        state.wrappedValue = .invalid
    }
    
    /// Resets validation state to neutral
    /// - Parameter state: Binding to the validation state to reset
    static func resetValidation(for state: Binding<ValidationState>) {
        state.wrappedValue = .neutral
    }
}

// MARK: - Common Configurations
public extension CustomTextField {
    
    /// Creates a name input field (letters only, capitalized)
    /// - Parameters:
    ///   - placeholder: Placeholder text
    ///   - text: Binding to the text value
    ///   - validationState: Binding to validation state
    ///   - colors: Custom colors
    /// - Returns: Configured CustomTextField for names
    static func nameField(
        placeholder: LocalizedStringKey = "firstName",
        text: Binding<String>,
        validationState: Binding<ValidationState> = .constant(.neutral),
        colors: ValidationColors = .default
    ) -> CustomTextField {
        return CustomTextField.triggered(
            placeholder: placeholder,
            text: text,
            type: .lettersOnly,
            validator: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
            errorMessage: "validation.name.invalid",
            validationState: validationState,
            colors: colors
        )
    }
    
    /// Creates an email input field
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - validationState: Binding to validation state
    ///   - colors: Custom colors
    /// - Returns: Configured CustomTextField for email
    static func emailField(
        text: Binding<String>,
        validationState: Binding<ValidationState> = .constant(.neutral),
        colors: ValidationColors = .default
    ) -> CustomTextField {
        return CustomTextField.triggered(
            placeholder: "email",
            text: text,
            type: .email,
            errorMessage: "validation.email.invalid",
            validationState: validationState,
            colors: colors
        )
    }
    
    /// Creates a password input field with strength validation
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - validationState: Binding to validation state
    ///   - colors: Custom colors
    /// - Returns: Configured CustomTextField for password
    static func passwordField(
        text: Binding<String>,
        validationState: Binding<ValidationState> = .constant(.neutral),
        colors: ValidationColors = .default
    ) -> CustomTextField {
        return CustomTextField.triggered(
            placeholder: "password",
            text: text,
            type: .password,
            errorMessage: "validation.password.requirements",
            validationState: validationState,
            colors: colors
        )
    }
}
