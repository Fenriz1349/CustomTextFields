![Swift](https://img.shields.io/badge/Swift-5.5+-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=apple&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0071E3?style=for-the-badge&logo=swift&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.1.0-blue?style=for-the-badge)

# CustomTextField

A powerful and customizable SwiftUI text field component with advanced validation states, flexible styling, and comprehensive input type support.

## Features

- 🎨 **Beautiful Design**: Pre-styled with shadows, borders, and smooth animations
- ✅ **Advanced Validation**: Multiple validation modes with visual state management
- 🎭 **Dynamic Visual Feedback**: Smart border colors based on validation state
- 🔐 **Security**: Secure text entry for passwords with configurable strength validation
- ⌨️ **Smart Keyboard**: Automatic keyboard type selection based on input type
- 🎨 **Customizable Colors**: Full color scheme customization for all validation states
- 🔄 **Flexible Validation Timing**: Choose between immediate or triggered validation
- 📋 **Pre-built Components**: Ready-to-use field types for common use cases
- 📱 **Native SwiftUI**: Fully compatible with SwiftUI and iOS design patterns

## Installation

### Swift Package Manager

Add CustomTextField to your project through Xcode:

1. Open your project in Xcode
2. Go to **File > Add Package Dependencies**
3. Enter the repository URL: `https://github.com/yourusername/CustomTextField`
4. Click **Add Package**

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/CustomTextField", from: "1.1.0")
]
```

## Quick Start

### Basic Example

```swift
import SwiftUI
import CustomTextField

struct ContentView: View {
    @State private var email = ""
    @State private var firstName = ""
    @State private var emailState: ValidationState = .neutral
    
    var body: some View {
        VStack(spacing: 20) {
            // Pre-configured email field
            CustomTextField.emailField(
                text: $email,
                validationState: $emailState
            )
            
            // Pre-configured name field  
            CustomTextField.nameField(
                placeholder: "First Name",
                text: $firstName
            )
            
            Button("Submit") {
                if !Validators.isValidEmail(email) {
                    emailState = .invalid
                }
            }
        }
        .padding()
    }
}
```

## Validation Modes

### 1. Triggered Validation (Recommended)

Shows validation errors only when manually triggered (e.g., form submission):

```swift
@State private var email = ""
@State private var emailState: ValidationState = .neutral

CustomTextField.triggered(
    placeholder: "Email",
    text: $email,
    type: .email,
    errorMessage: "Please enter a valid email",
    validationState: $emailState
)

// Trigger validation on button click
Button("Submit") {
    if !Validators.isValidEmail(email) {
        emailState = .invalid
    }
}
```

### 2. Immediate Validation

Shows validation feedback as soon as user types:

```swift
CustomTextField.immediate(
    placeholder: "Password",
    text: $password,
    type: .password,
    errorMessage: "Password requirements not met"
)
```

## Validation States

The component supports four distinct validation states:

| State | Description | Default Color | Usage |
|-------|-------------|---------------|-------|
| `.neutral` | Default state, no validation shown | Gray | Empty fields or before validation |
| `.valid` | Input passes validation | Green | Valid input confirmed |
| `.invalid` | Input fails validation | Red | Show errors to user |
| `.focused` | User is currently typing | Blue | Active input focus |

## Custom Color Schemes

### Pre-defined Schemes

```swift
// Default colors
CustomTextField(/* ... */, colors: .default)

// iOS system colors
CustomTextField(/* ... */, colors: .system)

// Custom mint scheme
CustomTextField(/* ... */, colors: .mint)
```

### Custom Color Scheme

```swift
let customColors = ValidationColors(
    neutral: .gray,
    valid: Color.green.opacity(0.8),
    invalid: Color.red.opacity(0.9),
    focused: Color.blue.opacity(0.7)
)

CustomTextField.triggered(
    placeholder: "Custom Field",
    text: $text,
    type: .email,
    validationState: $state,
    colors: customColors
)
```

## Text Field Types

| Type | Keyboard | Validation | Features |
|------|----------|------------|----------|
| `.email` | Email layout | Email format | No auto-correction, no caps |
| `.password` | ASCII capable | Strong password rules | Secure entry, no auto-correction |
| `.decimal` | Decimal pad | Valid number | Numeric input optimized |
| `.alphaNumber` | ASCII capable | Non-empty | Word caps, no auto-correction |
| `.lettersOnly` | Default | Letters, spaces, hyphens | Word caps, letters validation |
| `.number` | Number pad | Integer validation | Number input only |

## Pre-built Components

For common use cases, use the convenient pre-built components:

### Name Field
```swift
CustomTextField.nameField(
    placeholder: "First Name", // Optional, defaults to "Name"
    text: $firstName,
    validationState: $firstNameState,
    colors: .mint // Optional custom colors
)
```

### Email Field
```swift
CustomTextField.emailField(
    text: $email,
    validationState: $emailState
)
```

### Password Field
```swift
CustomTextField.passwordField(
    text: $password,
    validationState: $passwordState
)
```

## Advanced Validation

### Custom Validation Rules

```swift
// Using the example validation rules
CustomTextField.triggered(
    placeholder: "Username",
    text: $username,
    type: .alphaNumber,
    validator: ExampleValidationRules.validateUsername,
    errorMessage: "Username must be 3-20 characters, alphanumeric only",
    validationState: $usernameState
)

// Combining multiple validators
let strongNameValidator = ExampleValidationRules.allOf([
    ExampleValidationRules.validateFirstName,
    ExampleValidationRules.minimumLength(2),
    ExampleValidationRules.maximumLength(30)
])
```

### Built-in Validators

The package includes comprehensive validation utilities:

```swift
// Email validation
Validators.isValidEmail("user@example.com")

// Strong password (8+ chars, uppercase, lowercase, number, special char)
Validators.isStrongPassword("MyPass123!")

// Letters only (with spaces, hyphens, apostrophes)
Validators.isLettersOnly("Jean-Pierre O'Connor")

// Example validation rules
ExampleValidationRules.validateFirstName("John")
ExampleValidationRules.validateUSPhoneNumber("(555) 123-4567")
ExampleValidationRules.validateAge("25")
```

## Complete Form Example

```swift
struct RegistrationView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var firstNameState: ValidationState = .neutral
    @State private var lastNameState: ValidationState = .neutral
    @State private var emailState: ValidationState = .neutral
    @State private var passwordState: ValidationState = .neutral
    
    // Custom color scheme
    let customColors = ValidationColors.mint
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    CustomTextField.nameField(
                        placeholder: "First Name",
                        text: $firstName,
                        validationState: $firstNameState,
                        colors: customColors
                    )
                    
                    CustomTextField.nameField(
                        placeholder: "Last Name",
                        text: $lastName,
                        validationState: $lastNameState,
                        colors: customColors
                    )
                }
                
                Section("Account") {
                    CustomTextField.emailField(
                        text: $email,
                        validationState: $emailState,
                        colors: customColors
                    )
                    
                    CustomTextField.passwordField(
                        text: $password,
                        validationState: $passwordState,
                        colors: customColors
                    )
                }
                
                Section {
                    Button("Create Account") {
                        validateAndSubmit()
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Sign Up")
        }
    }
    
    private var isFormValid: Bool {
        ExampleValidationRules.validateFirstName(firstName) &&
        ExampleValidationRules.validateFirstName(lastName) &&
        Validators.isValidEmail(email) &&
        Validators.isStrongPassword(password)
    }
    
    private func validateAndSubmit() {
        var hasErrors = false
        
        if !ExampleValidationRules.validateFirstName(firstName) {
            firstNameState = .invalid
            hasErrors = true
        }
        
        if !ExampleValidationRules.validateFirstName(lastName) {
            lastNameState = .invalid
            hasErrors = true
        }
        
        if !Validators.isValidEmail(email) {
            emailState = .invalid
            hasErrors = true
        }
        
        if !Validators.isStrongPassword(password) {
            passwordState = .invalid
            hasErrors = true
        }
        
        if !hasErrors {
            // Submit form
            print("Form submitted successfully!")
        }
    }
}
```

## Validation Helper Methods

```swift
// Trigger error state
CustomTextField.triggerError(for: $emailState)

// Reset to neutral state
CustomTextField.resetValidation(for: $emailState)
```

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5.5+
- Xcode 13.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Make your changes
4. Run tests with `⌘+U`
5. Add tests for new functionality
6. Submit a pull request

## Testing

The package includes comprehensive unit tests:

```bash
# Run all tests
swift test

# Run specific test file
swift test --filter CustomTextFieldTests
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Fenriz1349**

## Changelog

### Version 1.1.0 ✨
- **NEW**: Advanced validation state management with `.neutral`, `.valid`, `.invalid`, and `.focused` states
- **NEW**: Customizable color schemes for all validation states
- **NEW**: Pre-built components: `nameField()`, `emailField()`, `passwordField()`
- **NEW**: Two validation modes: immediate and triggered validation
- **NEW**: Comprehensive example validation rules in `ExampleValidationRules`
- **NEW**: Helper methods for managing validation states
- **NEW**: Complete unit test suite
- **IMPROVED**: Better code organization with separated files
- **IMPROVED**: Enhanced documentation with real-world examples
- **BREAKING**: API changes for better flexibility (see migration guide)

### Version 1.0.0
- Initial release
- Support for email, password, decimal, and alphanumeric input types
- Built-in validation with custom validator support
- Beautiful default styling with animations

---

*Made with ❤️ for the SwiftUI community*
