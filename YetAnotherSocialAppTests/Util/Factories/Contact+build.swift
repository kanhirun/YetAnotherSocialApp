@testable import YetAnotherSocialApp

extension Contact {
    static func build(firstName: String = "some-first-name",
                      lastName: String = "some-last-name",
                      phoneNumber: NumericString? = nil) -> Contact {
        return Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    }
}
