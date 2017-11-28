import Quick
import Nimble

@testable import YetAnotherSocialApp

final class MessageServiceSpec: QuickSpec {
    override func spec() {

        describe("shared") {
            it("returns a singleton") {
                expect(MessageService.shared) == MessageService.shared
                expect(MessageService()) != MessageService()
            }
        }

    }
}
