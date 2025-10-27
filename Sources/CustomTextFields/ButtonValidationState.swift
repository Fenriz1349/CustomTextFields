//
//  ButtonValidationState.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 27/10/2025.
//

import SwiftUI

/// Represents the validation state of a form submit button
public enum ButtonValidationState: CaseIterable, Equatable {
    case disabled
    case enabled
    case error

    /// Returns a user-friendly description of the button state
    public var description: String {
        switch self {
        case .disabled: return "Disabled"
        case .enabled: return "Enabled"
        case .error: return "Error"
        }
    }

    /// Button background color based on state
    public var color: Color {
        switch self {
        case .disabled: return .gray.opacity(0.6)
        case .enabled: return .green
        case .error: return .red
        }
    }

    /// Whether the button should be enabled
    public var isEnabled: Bool {
        self != .disabled
    }
}
