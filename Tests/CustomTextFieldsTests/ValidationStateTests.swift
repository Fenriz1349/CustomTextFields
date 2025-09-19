//
//  ValidationStateTests.swift
//  CustomTextFields
//
//  Created by Julien Cotte on 19/09/2025.
//

import XCTest
@testable import CustomTextFields
import SwiftUI

final class ValidationStateTests: XCTestCase {
    
    // MARK: - ValidationState Tests
    func testValidationStateAllCases() {
        let expectedCases: [ValidationState] = [.neutral, .valid, .invalid, .focused]
        let actualCases = ValidationState.allCases
        
        XCTAssertEqual(actualCases.count, expectedCases.count)
        
        for expectedCase in expectedCases {
            XCTAssertTrue(actualCases.contains(expectedCase))
        }
    }
    
    func testValidationStateDescriptions() {
        XCTAssertEqual(ValidationState.neutral.description, "Neutral")
        XCTAssertEqual(ValidationState.valid.description, "Valid")
        XCTAssertEqual(ValidationState.invalid.description, "Invalid")
        XCTAssertEqual(ValidationState.focused.description, "Focused")
    }
    
    func testValidationStateEquality() {
        XCTAssertEqual(ValidationState.neutral, ValidationState.neutral)
        XCTAssertEqual(ValidationState.valid, ValidationState.valid)
        XCTAssertEqual(ValidationState.invalid, ValidationState.invalid)
        XCTAssertEqual(ValidationState.focused, ValidationState.focused)
        
        XCTAssertNotEqual(ValidationState.neutral, ValidationState.valid)
        XCTAssertNotEqual(ValidationState.valid, ValidationState.invalid)
        XCTAssertNotEqual(ValidationState.invalid, ValidationState.focused)
    }
    
    // MARK: - ValidationColors Tests
    func testValidationColorsInitialization() {
        let colors = ValidationColors()
        
        XCTAssertEqual(colors.neutral, .gray)
        XCTAssertEqual(colors.valid, .green)
        XCTAssertEqual(colors.invalid, .red)
        XCTAssertEqual(colors.focused, .blue)
    }
    
    func testValidationColorsCustomInitialization() {
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
    
    func testValidationColorsEquality() {
        let colors1 = ValidationColors()
        let colors2 = ValidationColors()
        let colors3 = ValidationColors(neutral: .black)
        
        XCTAssertEqual(colors1, colors2)
        XCTAssertNotEqual(colors1, colors3)
    }
    
    func testValidationColorsColorForState() {
        let colors = ValidationColors(
            neutral: .yellow,
            valid: .cyan,
            invalid: .red,
            focused: .indigo
        )
        
        XCTAssertEqual(colors.color(for: .neutral), .yellow)
        XCTAssertEqual(colors.color(for: .valid), .cyan)
        XCTAssertEqual(colors.color(for: .invalid), .red)
        XCTAssertEqual(colors.color(for: .focused), .indigo)
    }
    
    // MARK: - Predefined Color Schemes Tests
    func testDefaultColorScheme() {
        let defaultColors = ValidationColors.default
        
        XCTAssertEqual(defaultColors.neutral, .gray)
        XCTAssertEqual(defaultColors.valid, .green)
        XCTAssertEqual(defaultColors.invalid, .red)
        XCTAssertEqual(defaultColors.focused, .blue)
    }
    
    func testSystemColorScheme() {
        let systemColors = ValidationColors.system
        
        XCTAssertEqual(systemColors.neutral, Color(.systemGray4))
        XCTAssertEqual(systemColors.valid, Color(.systemGreen))
        XCTAssertEqual(systemColors.invalid, Color(.systemRed))
        XCTAssertEqual(systemColors.focused, Color(.systemBlue))
    }
    
    func testMintColorScheme() {
        let mintColors = ValidationColors.mint
        
        XCTAssertEqual(mintColors.neutral, .gray)
        XCTAssertEqual(mintColors.valid, .mint)
        XCTAssertEqual(mintColors.invalid, .red)
        XCTAssertEqual(mintColors.focused, .blue)
    }
    
    // MARK: - Color Consistency Tests
    func testColorSchemesConsistency() {
        let schemes = [
            ValidationColors.default,
            ValidationColors.system,
            ValidationColors.mint
        ]
        
        // Ensure all schemes have colors for all states
        for scheme in schemes {
            for state in ValidationState.allCases {
                let color = scheme.color(for: state)
                XCTAssertNotNil(color, "Color scheme should have a color for state: \(state)")
            }
        }
    }
    
    // MARK: - Performance Tests
    func testColorForStatePerformance() {
        let colors = ValidationColors.default
        
        measure {
            for _ in 0..<10000 {
                for state in ValidationState.allCases {
                    _ = colors.color(for: state)
                }
            }
        }
    }
    
    // MARK: - Edge Cases
    func testValidationStateHashable() {
        let stateSet: Set<ValidationState> = [.neutral, .valid, .invalid, .focused]
        XCTAssertEqual(stateSet.count, 4)
        
        // Test that duplicate states are handled correctly
        let duplicateSet: Set<ValidationState> = [.neutral, .neutral, .valid, .valid]
        XCTAssertEqual(duplicateSet.count, 2)
    }
    
    func testValidationColorsWithSameColors() {
          // Edge case: what happens when all colors are the same?
          let monochrome = ValidationColors(
              neutral: .gray,
              valid: .gray,
              invalid: .gray,
              focused: .gray
          )
          
          for state in ValidationState.allCases {
              XCTAssertEqual(monochrome.color(for: state), .gray)
          }
      }
      
      func testValidationStateRawValueStability() {
          // Ensure enum cases don't change unexpectedly (important for persistence)
          // This test would catch if someone reorders the enum cases
          let states = ValidationState.allCases
          XCTAssertTrue(states.contains(.neutral))
          XCTAssertTrue(states.contains(.valid))
          XCTAssertTrue(states.contains(.invalid))
          XCTAssertTrue(states.contains(.focused))
      }
  }
