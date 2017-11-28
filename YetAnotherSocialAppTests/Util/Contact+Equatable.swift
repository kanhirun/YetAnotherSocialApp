@testable import YetAnotherSocialApp

extension Contact: Equatable {
    public static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName &&
               lhs.lastName == rhs.lastName
    }
}
