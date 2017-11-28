@testable import YetAnotherSocialApp

extension Message {
    static func build(to recipient: String? = "some-recipient",
                      body: String? = "some-body") -> Message {
        return Message(to: recipient, body: body)
    }
}

