import Quick
import Nimble

@testable import YetAnotherSocialApp
import GoogleMaps
import CoreLocation

final class PlaceViewModelSpec: QuickSpec {

    override func spec() {

        var viewModel: PlaceViewModel!

        var selectedPlaces: PlaceService!
        var selectedContacts: ContactService!
        var sentMessages: MessageService!

        beforeEach {
            selectedPlaces = PlaceService(client: FakePlacesClient())
            selectedContacts = ContactService()
            sentMessages = MessageService()

            viewModel = PlaceViewModel(places: selectedPlaces,
                                       contacts: selectedContacts,
                                       messages: sentMessages)
        }

        context("when both texts are present") {
            var placeText: String?
            var contactText: String?

            beforeEach {
                selectedPlaces.latest.value = Place.build()
                selectedContacts.latest.value = Contact.build()

                viewModel.placeText.startWithValues { newText in
                    placeText = newText
                }

                viewModel.contactText.startWithValues { newText in
                    contactText = newText
                }

                expect(placeText).toNot(beNil())
                expect(contactText).toNot(beNil())
            }

            it("clears the text fields after a message is sent") {
                sentMessages.observer.send(value: Message.build())

                expect(placeText).to(beNil())
                expect(contactText).to(beNil())
            }
        }

        describe("messageRecipient") {
            it("returns nil if the contact has no phone number") {
                selectedContacts.latest.value = Contact.build(phoneNumber: nil)
                expect(viewModel.messageRecipient).to(beNil())
            }

            it("returns nil if there's no contact") {
                expect(selectedContacts.latest.value).to(beNil())
                expect(viewModel.messageRecipient).to(beNil())
            }

            it("returns a singleton array with the contact's phone number") {
                selectedContacts.latest.value = Contact.build(phoneNumber: "123")
                expect(viewModel.messageRecipient) == ["123"]
            }
        }

        describe("messageBody") {
            it("returns nil if either contact or place is unselected") {
                selectedContacts.latest.value = nil

                expect(viewModel.messageBody).to(beNil())
            }

            it("returns a body") {
                selectedContacts.latest.value = Contact.build(firstName: "Benny")
                selectedPlaces.latest.value = Place.build(name: "Stash")

                expect(viewModel.messageBody) == "Hey Benny, I heard Stash is AWESOME. Let's go!"
            }
        }

        describe("placeSelected") {
            it("returns an updated camera located on the place") {
                let placeCoordinate = CLLocationCoordinate2D(latitude: 10, longitude: 20)
                selectedPlaces.latest.value = Place.build(coordinate: placeCoordinate)

                var updatedCamera: GMSCameraPosition?
                viewModel.placeSelected.startWithValues { camera in
                    updatedCamera = camera
                }

                expect(updatedCamera?.target.latitude) == placeCoordinate.latitude
                expect(updatedCamera?.target.longitude) == placeCoordinate.longitude
            }
        }

    }

}
