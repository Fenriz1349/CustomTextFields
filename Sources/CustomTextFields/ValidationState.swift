//
//  ValidationState.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 19/09/2025.
//


import SwiftUI

/// Represents the current validation state of a text field
public enum ValidationState: CaseIterable, Equatable {
    case neutral
    case valid
    case invalid
    case focused
    
    /// Returns a user-friendly description of the validation state
    public var description: String {
        switch self {
        case .neutral: return "Neutral"
        case .valid: return "Valid"
        case .invalid: return "Invalid"
        case .focused: return "Focused"
        }
    }
}

/// Configuration for validation colors used in CustomTextField
public struct ValidationColors: Equatable, Sendable {
    public let neutral: Color
    public let valid: Color
    public let invalid: Color
    public let focused: Color
    
    public init(
        neutral: Color = .gray,
        valid: Color = .green,
        invalid: Color = .red,
        focused: Color = .blue
    ) {
        self.neutral = neutral
        self.valid = valid
        self.invalid = invalid
        self.focused = focused
    }
    
    /// Default color scheme
    public static let `default` = ValidationColors()
    
    /// iOS system colors scheme
    public static let system = ValidationColors(
        neutral: Color(.systemGray4),
        valid: Color(.systemGreen),
        invalid: Color(.systemRed),
        focused: Color(.systemBlue)
    )
    
    /// Custom green scheme example
    public static let mint = ValidationColors(
        neutral: .gray,
        valid: .mint,
        invalid: .red,
        focused: .blue
    )
    
    /// Get color for a specific validation state
    public func color(for state: ValidationState) -> Color {
        switch state {
        case .neutral: return neutral
        case .valid: return valid
        case .invalid: return invalid
        case .focused: return focused
        }
    }
}
