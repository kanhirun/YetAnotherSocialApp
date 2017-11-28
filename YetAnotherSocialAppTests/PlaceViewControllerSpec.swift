import Quick
import Nimble
import ReactiveSwift
import MessageUI
import ContactsUI
@testable import YetAnotherSocialApp

final class PlaceViewControllerSpec: QuickSpec {
    override func spec() {

        var controller: PlaceViewController!

        var selectedPlaces: PlaceService!
        var selectedContacts: ContactService!
        var sentMessages: MessageService!

        beforeEach {
            selectedPlaces = PlaceService(client: FakePlacesClient())
            selectedContacts = ContactService()
            sentMessages = MessageService()

            controller = TestFactory.create(PlaceViewController.self,
                                            selectedPlaces: selectedPlaces,
                                            selectedContacts: selectedContacts,
                                            sentMessages: sentMessages)
        }

        describe("Place Text Field") {
            it("shows a placeholder when no place is selected") {
                expect(controller.placeTextField.text).to(beEmpty())
                expect(controller.placeTextField.placeholder) == "Search Place"
            }

            it("shows their name when places are selected") {
                selectedPlaces.latest.value = Place.build(name: "New York")
                expect(controller.placeTextField.text) == "New York"

                selectedPlaces.latest.value = Place.build(name: "Chicago")
                expect(controller.placeTextField.text) == "Chicago"
            }

            xit("presents a search controller when tapped") {
                controller.placeTextField.sendActions(for: .primaryActionTriggered)
                _ = controller.placeTextField.delegate?.textFieldShouldBeginEditing!(controller.placeTextField)

                expect(controller.presentedViewController)
                    .toEventually(beAnInstanceOf(PlaceSearchViewController.self))
            }

            xit("centers the camera on the place") {}
        }

        describe("Contact Text Field") {
            xit("presents a picker controller when tapped") {
                controller.contactTextField.sendActions(for: .primaryActionTriggered)
                _ = controller.contactTextField.delegate?.textFieldShouldBeginEditing!(controller.placeTextField)

                expect(controller.presentedViewController)
                    .toEventually(beAnInstanceOf(CNContactPickerViewController.self))
            }

            it("shows a placeholder when no contact is selected") {
                expect(controller.contactTextField.text).to(beEmpty())
                expect(controller.contactTextField.placeholder) == "Choose Contact"
            }

            it("shows their full name when a contact is selected") {
                selectedContacts.latest.value = Contact.build(firstName: "Alice", lastName: "Doe")
                expect(controller.contactTextField.text) == "Alice Doe"

                selectedContacts.latest.value = Contact.build(firstName: "Bob", lastName: "Doe")
                expect(controller.contactTextField.text) == "Bob Doe"
            }
        }

        describe("Send Button") {
            xit("presents a message controller when tapped") {}
            xit("fills a message with information") {}

            it("is disabled when one of the required fields are empty") {
                expect(controller.sendButton).to(beDisabled())

                selectedPlaces.latest.value = Place.build(name: "New York")

                expect(controller.sendButton).to(beDisabled())

                selectedContacts.latest.value = Contact.build(firstName: "Alice", lastName: "Doe")

                expect(controller.sendButton).toNot(beDisabled())
            }
        }

    }
}
