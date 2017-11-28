struct Message {

    let recipient: String?
    let body: String?

    init(to recipient: String?, body: String?) {
        self.recipient = recipient
        self.body = body
    }

}
