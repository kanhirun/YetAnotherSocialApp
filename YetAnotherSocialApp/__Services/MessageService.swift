import ReactiveSwift
import Result
import MessageUI
import UIKit

class MessageService: NSObject {

    static let shared = MessageService()

    // The latest messages sent from the user
    let latest: Signal<Message, NoError>

    let observer: Signal<Message, NoError>.Observer

    override init() {
        (self.latest, self.observer) = Signal<Message, NoError>.pipe()

        super.init()
    }
}
