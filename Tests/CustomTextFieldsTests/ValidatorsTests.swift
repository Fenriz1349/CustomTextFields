import XCTest
@testable import CustomTextFields

final class ValidatorsTests: XCTestCase {

    func testValidEmail() {
        XCTAssertTrue(Validators.isValidEmail("test@example.com"))
        XCTAssertFalse(Validators.isValidEmail("invalid-email"))
    }

    func testStrongPassword() {
        XCTAssertTrue(Validators.isStrongPassword("Valid1!Pass"))
        XCTAssertFalse(Validators.isStrongPassword("weakpass"))
        XCTAssertFalse(Validators.isStrongPassword("Short1!"))
        XCTAssertFalse(Validators.isStrongPassword("NoSpecial123"))
        XCTAssertFalse(Validators.isStrongPassword("NOSYMBOL!"))
    }
}
