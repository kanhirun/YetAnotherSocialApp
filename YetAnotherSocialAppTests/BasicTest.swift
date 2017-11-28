import Quick
import Nimble

class BasicTest: QuickSpec {
    override func spec() {
        describe("a basic test") {
            it("returns true") {
                expect(true).to(beTrue())
            }
        }
    }
}
