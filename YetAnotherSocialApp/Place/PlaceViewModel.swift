import ReactiveSwift
import Result
import GoogleMaps
import Contacts
import ContactsUI
import MessageUI

final class PlaceViewModel: NSObject {

    let placeText: SignalProducer<String?, NoError>

    let contactText: SignalProducer<String?, NoError>

    // Sends a boolean indicating whether the button should be enabled
    let sendButtonEnabled: Property<Bool>

    // The camera where the place is selected
    let placeSelected: SignalProducer<GMSCameraPosition, NoError>

    // The map components where the message was sent
    let messageSent: SignalProducer<(GMSMarker, GMSCameraPosition), NoError>

    // The message body to be used
    var messageBody: String? {
        guard let contact = contacts.latest.value, let place = places.latest.value else {
            return nil
        }
        return "Hey \(contact.firstName), I heard \(place.name) is AWESOME. Let's go!"
    }

    // The message recipient to be used
    var messageRecipient: [String]? {
        guard let phoneNumber = contacts.latest.value?.phoneNumber else {
            return nil
        }
        return [phoneNumber]
    }

    private let places: PlaceService
    private let contacts: ContactService
    private let messages: MessageService

    init(places: PlaceService, contacts: ContactService, messages: MessageService) {
        self.places = places
        self.contacts = contacts
        self.messages = messages
        self.placeText = places.names
        self.contactText = contacts.names

        // Enables the button when both fields are present
        self.sendButtonEnabled = places.latest
            .combineLatest(with: contacts.latest)
            .map { $0 != nil && $1 != nil }

        self.placeSelected = places.mapComponents
            .map { _, _, camera in
                return camera
            }

        self.messageSent = messages.latest.producer
            .combineLatest(with: places.mapComponents)
            .map { (_, mapComponents) -> (GMSMarker, GMSCameraPosition) in
                let (_, marker, camera) = mapComponents

                return (marker, camera)
            }

        super.init()

        // Resets the fields after a message is sent
        messages.latest.producer.startWithValues { _ in
            self.places.latest.value = nil
            self.contacts.latest.value = nil
        }
    }
}


extension PlaceViewModel: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        contacts.latest.value = Contact(contact)
    }
}

extension PlaceViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            let recipient = controller.recipients?.first
            let message = Message(to: recipient, body: controller.body)

            messages.observer.send(value: message)
        default:
            break
        }

        controller.dismiss(animated: true, completion: nil)
    }
}

