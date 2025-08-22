//
//  Validators.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 22/08/2025.
//

import Foundation

public enum Validators {
    public static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    /// Validates whether the given password is strong.
    /// A strong password must contain:
    /// - At least one uppercase letter
    /// - At least one lowercase letter
    /// - At least one digit
    /// - At least one special character (e.g., !@#$%^&*(),.?":{}|<>)
    /// - Minimum length of 8 characters
    ///
    /// - Parameter password: The password string to validate.
    /// - Returns: `true` if the password meets all criteria, otherwise `false`.
    public static func isStrongPassword(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }}
