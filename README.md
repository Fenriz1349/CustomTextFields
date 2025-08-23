# CustomTextField

A powerful and customizable SwiftUI text field component with built-in validation, beautiful styling, and comprehensive input type support.

## Features

- 🎨 **Beautiful Design**: Pre-styled with shadows, borders, and smooth animations
- ✅ **Built-in Validation**: Email, password strength, decimal, and custom validation support
- 🔐 **Security**: Secure text entry for passwords with strong validation
- ⌨️ **Smart Keyboard**: Automatic keyboard type selection based on input type
- 🎭 **Visual Feedback**: Dynamic border colors and error messages
- 🔄 **Real-time Validation**: Instant feedback as users type
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
    .package(url: "https://github.com/yourusername/CustomTextField", from: "1.0.0")
]
```

## Usage

### Basic Example

```swift
import SwiftUI
import CustomTextField

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var amount = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(
                header: "Email Address",
                placeholder: "Enter your email",
                text: $email,
                type: .email,
                errorMessage: "Please enter a valid email address"
            )
            
            CustomTextField(
                header: "Password",
                placeholder: "Enter your password",
                text: $password,
                type: .password,
                errorMessage: "Password must be at least 8 characters with uppercase, lowercase, number, and special character"
            )
            
            CustomTextField(
                header: "Amount",
                placeholder: "0.00",
                text: $amount,
                type: .decimal,
                errorMessage: "Please enter a valid number"
            )
        }
        .padding()
    }
}
```

### Advanced Usage with Custom Validation

```swift
CustomTextField(
    header: "Username",
    placeholder: "Enter username",
    text: $username,
    type: .alphaNumber,
    validator: { input in
        return input.count >= 3 && input.count <= 20
    },
    errorMessage: "Username must be between 3-20 characters"
)
```

## Text Field Types

CustomTextField supports four built-in input types:

### `.email`
- **Keyboard**: Email keyboard layout
- **Validation**: Standard email format validation
- **Features**: Auto-correction disabled, no capitalization

### `.password`
- **Keyboard**: ASCII capable keyboard
- **Validation**: Strong password requirements:
  - Minimum 8 characters
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one digit
  - At least one special character (`!@#$%^&*(),.?":{}|<>`)
- **Features**: Secure text entry, auto-correction disabled

### `.decimal`
- **Keyboard**: Decimal pad
- **Validation**: Valid decimal number
- **Features**: Optimized for numeric input

### `.alphaNumber`
- **Keyboard**: ASCII capable keyboard
- **Validation**: Non-empty string
- **Features**: Word capitalization, auto-correction disabled

## Customization Options

### Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `header` | `String?` | Optional header text above the field | `nil` |
| `placeholder` | `String` | Placeholder text shown when field is empty | Required |
| `text` | `Binding<String>` | Binding to the text value | Required |
| `type` | `TextFieldType` | Input type configuration | Required |
| `validator` | `((String) -> Bool)?` | Custom validation function | `nil` |
| `errorMessage` | `String?` | Error message shown on validation failure | `nil` |

### Visual States

The text field automatically adapts its appearance based on the current state:

- **Empty**: Gray border
- **Valid Input**: Green border
- **Invalid Input**: Red border with error message
- **Focus**: Subtle shadow and smooth transitions

## Validation

### Built-in Validators

The package includes a `Validators` utility class with pre-built validation functions:

```swift
// Email validation
Validators.isValidEmail("user@example.com") // Returns Bool

// Strong password validation
Validators.isStrongPassword("MyPass123!") // Returns Bool
```

### Custom Validation

You can provide your own validation logic:

```swift
CustomTextField(
    placeholder: "Product Code",
    text: $productCode,
    type: .alphaNumber,
    validator: { code in
        // Custom validation: must start with "PRD" and be 8 characters
        return code.hasPrefix("PRD") && code.count == 8
    },
    errorMessage: "Product code must start with 'PRD' and be 8 characters long"
)
```

## Examples

### Login Form

```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            CustomTextField(
                header: "Email",
                placeholder: "your@email.com",
                text: $email,
                type: .email,
                errorMessage: "Please enter a valid email"
            )
            
            CustomTextField(
                header: "Password",
                placeholder: "Your password",
                text: $password,
                type: .password,
                errorMessage: "Password requirements not met"
            )
            
            Button("Sign In") {
                // Handle login
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
        .padding()
    }
}
```

### Registration Form

```swift
struct RegistrationView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CustomTextField(
                    header: "First Name",
                    placeholder: "John",
                    text: $firstName,
                    type: .alphaNumber,
                    errorMessage: "First name is required"
                )
                
                CustomTextField(
                    header: "Last Name",
                    placeholder: "Doe",
                    text: $lastName,
                    type: .alphaNumber,
                    errorMessage: "Last name is required"
                )
                
                CustomTextField(
                    header: "Email",
                    placeholder: "john.doe@example.com",
                    text: $email,
                    type: .email,
                    errorMessage: "Please enter a valid email"
                )
                
                CustomTextField(
                    header: "Password",
                    placeholder: "Create a strong password",
                    text: $password,
                    type: .password,
                    errorMessage: "Password must meet security requirements"
                )
                
                CustomTextField(
                    header: "Confirm Password",
                    placeholder: "Confirm your password",
                    text: $confirmPassword,
                    type: .password,
                    validator: { input in
                        return input == password
                    },
                    errorMessage: "Passwords don't match"
                )
            }
            .padding()
        }
    }
}
```

## Requirements

- iOS 14.0+
- macOS 11.0+
- tvOS 14.0+
- watchOS 7.0+
- Swift 5.5+
- Xcode 13.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Fenriz1349**

## Changelog

### Version 1.0.0
- Initial release
- Support for email, password, decimal, and alphanumeric input types
- Built-in validation with custom validator support
- Beautiful default styling with animations
- Comprehensive documentation and examples

---
