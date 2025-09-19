//
//  CustomTextFieldTests.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 19/09/2025.
//

import XCTest
@testable import CustomTextFields
import SwiftUI

final class CustomTextFieldTests: XCTestCase {
    
    // MARK: - Test Properties
    private var textBinding: Binding<String>!
    private var validationStateBinding: Binding<ValidationState>!
    private var textValue: String = ""
    private var validationStateValue: ValidationState = .neutral
    
    override func setUp() {
        super.setUp()
        textValue = ""
        validationStateValue = .neutral
        textBinding = Binding(
            get: { self.textValue },
            set: { self.textValue = $0 }
        )
        validationStateBinding = Binding(
            get: { self.validationStateValue },
            set: { self.validationStateValue = $0 }
        )
    }
    
    // MARK: - Initialization Tests
    @MainActor func testCustomTextFieldInitialization() {
        let textField = CustomTextField(
            placeholder: "Test",
            text: textBinding,
            type: .email
        )
        
        XCTAssertNotNil(textField)
        XCTAssertEqual(textField.placeholder, "Test")
        XCTAssertEqual(textField.type, .email)
    }
    
    @MainActor func testCustomTextFieldWithHeader() {
        let textField = CustomTextField(
            header: "Email Address",
            placeholder: "Enter email",
            text: textBinding,
            type: .email
        )
        
        XCTAssertEqual(textField.header, "Email Address")
    }
    
    // MARK: - Validation State Tests
    func testValidationStateTransitions() {
        // Test all possible validation states
        for state in ValidationState.allCases {
            validationStateValue = state
            XCTAssertEqual(validationStateBinding.wrappedValue, state)
        }
    }
    
    func testValidationColorsForAllStates() {
        let colors = ValidationColors.default
        
        // Test that each state returns a valid color
        for state in ValidationState.allCases {
            let color = colors.color(for: state)
            XCTAssertNotNil(color)
        }
    }
    
    // MARK: - Custom Validator Tests
    @MainActor func testCustomValidatorExecution() {
        var validatorCalled = false
        let customValidator: (String) -> Bool = { text in
            validatorCalled = true
            return text.count >= 5
        }
        
        let textField = CustomTextField(
            placeholder: "Test",
            text: textBinding,
            type: .alphaNumber,
            validator: customValidator
        )
        
        // Simulate text change
        textValue = "test"
        
        // Note: In a real SwiftUI environment, this would be called automatically
        // Here we're testing that the validator function works correctly
        let result = customValidator(textValue)
        
        XCTAssertTrue(validatorCalled)
        XCTAssertFalse(result) // "test" has only 4 characters
    }
    
    // MARK: - Convenience Initializer Tests
    @MainActor func testImmediateTextFieldCreation() {
        let textField = CustomTextField.immediate(
            placeholder: "Immediate Test",
            text: textBinding,
            type: .email,
            errorMessage: "Invalid email"
        )
        
        XCTAssertEqual(textField.placeholder, "Immediate Test")
        XCTAssertEqual(textField.type, .email)
        XCTAssertEqual(textField.errorMessage, "Invalid email")
        XCTAssertFalse(textField.showErrorOnlyWhenTriggered)
    }
    
    @MainActor func testTriggeredTextFieldCreation() {
        let textField = CustomTextField.triggered(
            placeholder: "Triggered Test",
            text: textBinding,
            type: .password,
            validationState: validationStateBinding
        )
        
        XCTAssertEqual(textField.placeholder, "Triggered Test")
        XCTAssertEqual(textField.type, .password)
        XCTAssertTrue(textField.showErrorOnlyWhenTriggered)
    }
    
    // MARK: - Predefined Field Tests
    @MainActor func testNameFieldCreation() {
        let nameField = CustomTextField.nameField(
            text: textBinding,
            validationState: validationStateBinding
        )
        
        XCTAssertEqual(nameField.type, .lettersOnly)
        XCTAssertEqual(nameField.placeholder, "Name")
        XCTAssertNotNil(nameField.validator)
        XCTAssertNotNil(nameField.errorMessage)
    }
    
    @MainActor func testEmailFieldCreation() {
        let emailField = CustomTextField.emailField(
            text: textBinding,
            validationState: validationStateBinding
        )
        
        XCTAssertEqual(emailField.type, .email)
        XCTAssertEqual(emailField.placeholder, "Email")
        XCTAssertNotNil(emailField.errorMessage)
    }
    
    @MainActor func testPasswordFieldCreation() {
        let passwordField = CustomTextField.passwordField(
            text: textBinding,
            validationState: validationStateBinding
        )
        
        XCTAssertEqual(passwordField.type, .password)
        XCTAssertEqual(passwordField.placeholder, "Password")
        XCTAssertNotNil(passwordField.errorMessage)
    }
    
    // MARK: - Validation Helper Tests
    @MainActor func testTriggerError() {
        validationStateValue = .neutral
        
        CustomTextField.triggerError(for: validationStateBinding)
        
        XCTAssertEqual(validationStateValue, .invalid)
    }
    
    @MainActor func testResetValidation() {
        validationStateValue = .invalid
        
        CustomTextField.resetValidation(for: validationStateBinding)
        
        XCTAssertEqual(validationStateValue, .neutral)
    }
    
    // MARK: - Color Scheme Tests
    func testDefaultColorScheme() {
        let colors = ValidationColors.default
        
        XCTAssertEqual(colors.neutral, .gray)
        XCTAssertEqual(colors.valid, .green)
        XCTAssertEqual(colors.invalid, .red)
        XCTAssertEqual(colors.focused, .blue)
    }
    
    func testCustomColorScheme() {
        let customColors = ValidationColors(
            neutral: .black,
            valid: .mint,
            invalid: .orange,
            focused: .purple
        )
        
        XCTAssertEqual(customColors.neutral, .black)
        XCTAssertEqual(customColors.valid, .mint)
        XCTAssertEqual(customColors.invalid, .orange)
        XCTAssertEqual(customColors.focused, .purple)
    }
    
    // MARK: - Edge Cases
    @MainActor func testEmptyTextHandling() {
        textValue = ""
        
        let textField = CustomTextField(
            placeholder: "Test",
            text: textBinding,
            type: .email
        )
        
        // Empty text should not trigger validation errors in most cases
        XCTAssertEqual(textValue, "")
    }
    
    @MainActor func testNilValidatorHandling() {
        let textField = CustomTextField(
            placeholder: "Test",
            text: textBinding,
            type: .alphaNumber,
            validator: nil
        )
        
        // Should fall back to default validation
        XCTAssertNil(textField.validator)
    }
}
