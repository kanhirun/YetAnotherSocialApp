import Quick
import Nimble
import Contacts

@testable import YetAnotherSocialApp

final class ContactSpec: QuickSpec {
    override func spec() {

        describe("init(_ other:)") {
            it("creates a contact from other type") {
                let otherType = CNMutableContact()
                otherType.givenName = "Dorian"
                otherType.familyName = "Gray"

                let dorianGray = Contact(otherType)

                expect(dorianGray.firstName) == "Dorian"
                expect(dorianGray.lastName) == "Gray"
            }

            it("doesn't have a phone number if empty") {
                let otherType = CNMutableContact()
                otherType.phoneNumbers = []

                let noPhoneNumber = Contact(otherType)

                expect(noPhoneNumber.phoneNumber).to(beNil())
            }

            it("returns the first phone number from the list") {
                let otherType = CNMutableContact()
                otherType.phoneNumbers = [
                    CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "1")),
                    CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "9999")),
                ]

                let manyPhoneNumbers = Contact(otherType)

                expect(manyPhoneNumbers.phoneNumber) == "1"
            }
        }

        describe("init(phoneNumber:)") {
            it("formats bad strings so that it is numeric") {
                let badString = "(123) 456-7890"

                let results = Contact.build(phoneNumber: badString)

                expect(results.phoneNumber) == "1234567890"
            }

            it("returns itself when the phone number is numeric") {
                let numeric = "1234567890"

                let results = Contact.build(phoneNumber: numeric)

                expect(results.phoneNumber) == numeric
            }

            it("returns nil if there's no phone number") {
                let noPhoneNumber = Contact.build(phoneNumber: nil)

                expect(noPhoneNumber.phoneNumber).to(beNil())
            }
        }

        describe("fullName") {
            it("returns the first and last name") {
                let contact = Contact.build(firstName: "Jane", lastName: "Doe")

                expect(contact.fullName) == "Jane Doe"
            }
        }

    }
}
