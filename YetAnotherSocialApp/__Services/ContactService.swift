import ReactiveSwift
import Result
import ContactsUI

final class ContactService: NSObject {

    static let shared = ContactService()

    // The names of the contacts selected by the user
    let names: SignalProducer<String?, NoError>

    // The phone numbers of the contacts selected by the user
    let phoneNumbers: SignalProducer<NumericString?, NoError>

    // The latest contacts selected by the user
    let latest = MutableProperty<Contact?>(nil)

    override init() {
        self.names = latest.producer.map { $0?.fullName }
        self.phoneNumbers = latest.producer.map { $0?.phoneNumber }

        super.init()
    }

}

extension ContactService: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        latest.value = Contact(contact)
    }
}
