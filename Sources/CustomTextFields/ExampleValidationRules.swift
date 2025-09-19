//
//  ExampleValidationRules.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 19/09/2025.
//

import Foundation

/// Example validation rules that can be used with CustomTextField
/// These are common patterns you can copy and adapt in your own apps
public enum ExampleValidationRules {
    
    // MARK: - Name Validation
    
    /// Validates first name - allows letters, spaces, hyphens, and apostrophes
    /// Minimum 2 characters, maximum 50 characters
    public static func validateFirstName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 && trimmed.count <= 50 else { return false }
        return Validators.isLettersOnly(trimmed)
    }
    
    /// Validates last name with same rules as first name
    public static func validateLastName(_ name: String) -> Bool {
        return validateFirstName(name)
    }
    
    /// Validates full name (first + last)
    public static func validateFullName(_ fullName: String) -> Bool {
        let components = fullName.components(separatedBy: " ")
        guard components.count >= 2 else { return false }
        
        return components.allSatisfy { component in
            let trimmed = component.trimmingCharacters(in: .whitespacesAndNewlines)
            return !trimmed.isEmpty && Validators.isLettersOnly(trimmed)
        }
    }
    
    // MARK: - Password Validation
    
    /// Basic password validation - minimum 6 characters
    public static func validateBasicPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    /// Medium strength password - 8+ chars with letters and numbers
    public static func validateMediumPassword(_ password: String) -> Bool {
        let hasMinLength = password.count >= 8
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasMinLength && hasLetter && hasNumber
    }
    
    /// Uses the strong password from Validators (uppercase, lowercase, number, special char, 8+ chars)
    public static func validateStrongPassword(_ password: String) -> Bool {
        return Validators.isStrongPassword(password)
    }
    
    // MARK: - Age Validation
    
    /// Validates age between 13 and 120
    public static func validateAge(_ ageString: String) -> Bool {
        guard let age = Int(ageString) else { return false }
        return age >= 13 && age <= 120
    }
    
    /// Validates age for adults (18+)
    public static func validateAdultAge(_ ageString: String) -> Bool {
        guard let age = Int(ageString) else { return false }
        return age >= 18 && age <= 120
    }
    
    // MARK: - Phone Number Validation
    
    /// Basic phone number validation (digits, spaces, hyphens, parentheses, plus)
    public static func validatePhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = #"^[\d\s\-\(\)\+]{10,15}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    /// US phone number validation (more strict)
    public static func validateUSPhoneNumber(_ phone: String) -> Bool {
        // Remove all non-digits
        let digitsOnly = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // US phone numbers should have 10 digits (or 11 with country code)
        return digitsOnly.count == 10 || (digitsOnly.count == 11 && digitsOnly.hasPrefix("1"))
    }
    
    // MARK: - Username Validation
    
    /// Validates username - alphanumeric plus underscore, 3-20 characters
    public static func validateUsername(_ username: String) -> Bool {
        let usernameRegex = #"^[a-zA-Z0-9_]{3,20}$"#
        return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
    }
    
    /// Validates username with more restrictive rules (no underscore at start/end)
    public static func validateStrictUsername(_ username: String) -> Bool {
        let strictUsernameRegex = #"^[a-zA-Z0-9][a-zA-Z0-9_]{1,18}[a-zA-Z0-9]$"#
        return NSPredicate(format: "SELF MATCHES %@", strictUsernameRegex).evaluate(with: username)
    }
    
    // MARK: - Numeric Validation
    
    /// Validates positive integer
    public static func validatePositiveInteger(_ numberString: String) -> Bool {
        guard let number = Int(numberString) else { return false }
        return number > 0
    }
    
    /// Validates number within range
    public static func validateNumberInRange(_ numberString: String, min: Int, max: Int) -> Bool {
        guard let number = Int(numberString) else { return false }
        return number >= min && number <= max
    }
    
    /// Validates decimal number with up to 2 decimal places
    public static func validateCurrency(_ currencyString: String) -> Bool {
        let currencyRegex = #"^\d+(\.\d{1,2})?$"#
        return NSPredicate(format: "SELF MATCHES %@", currencyRegex).evaluate(with: currencyString)
    }
    
    // MARK: - Text Length Validation
    
    /// Creates a validator for minimum length
    public static func minimumLength(_ minLength: Int) -> (String) -> Bool {
        return { text in
            text.trimmingCharacters(in: .whitespacesAndNewlines).count >= minLength
        }
    }
    
    /// Creates a validator for maximum length
    public static func maximumLength(_ maxLength: Int) -> (String) -> Bool {
        return { text in
            text.count <= maxLength
        }
    }
    
    /// Creates a validator for length range
    public static func lengthRange(min: Int, max: Int) -> (String) -> Bool {
        return { text in
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.count >= min && trimmed.count <= max
        }
    }
    
    // MARK: - Combination Validators
    
    /// Combines multiple validators with AND logic
    public static func allOf(_ validators: [(String) -> Bool]) -> (String) -> Bool {
        return { text in
            validators.allSatisfy { $0(text) }
        }
    }
    
    /// Combines multiple validators with OR logic
    public static func anyOf(_ validators: [(String) -> Bool]) -> (String) -> Bool {
        return { text in
            validators.contains { $0(text) }
        }
    }
    
    // MARK: - Real-world Examples
    
    /// Validates a complete registration form first name
    public static let registrationFirstName = allOf([
        validateFirstName,
        minimumLength(2),
        maximumLength(30)
    ])
    
    /// Validates a complete registration form email
    public static let registrationEmail = Validators.isValidEmail
    
    /// Validates a complete registration form password
    public static let registrationPassword = validateMediumPassword
    
    // MARK: - Custom Business Logic Examples
    
    /// Example: Company-specific employee ID validation
    public static func validateEmployeeID(_ id: String) -> Bool {
        // Example: EMP-XXXX format where X is a digit
        let empIdRegex = #"^EMP-\d{4}$"#
        return NSPredicate(format: "SELF MATCHES %@", empIdRegex).evaluate(with: id)
    }
    
    /// Example: Product code validation (3 letters + 3 numbers)
    public static func validateProductCode(_ code: String) -> Bool {
        let productCodeRegex = #"^[A-Z]{3}\d{3}$"#
        return NSPredicate(format: "SELF MATCHES %@", productCodeRegex).evaluate(with: code.uppercased())
    }
}
