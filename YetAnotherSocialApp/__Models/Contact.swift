import Contacts

typealias NumericString = String

struct Contact {
    let firstName: String
    let lastName: String
    let phoneNumber: NumericString?

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    init(_ other: CNContact) {
        self.init(firstName: other.givenName,
                  lastName: other.familyName,
                  phoneNumber: other.phoneNumbers.first?.value.stringValue)
    }

    init(firstName: String, lastName: String, phoneNumber: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = (phoneNumber != nil) ? Contact.makeNumeric(phoneNumber!) : nil
    }

    private static func makeNumeric(_ rawString: String) -> NumericString {
        return rawString.filter { Int(String($0)) != nil }
    }
}
