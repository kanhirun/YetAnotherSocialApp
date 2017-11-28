@testable import YetAnotherSocialApp

extension Message: Equatable {
    public static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.recipient == rhs.recipient &&
               lhs.body == rhs.body
    }
}

