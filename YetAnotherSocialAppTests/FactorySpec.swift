import Quick
import Nimble

@testable import YetAnotherSocialApp

final class FactorySpec: QuickSpec {
    override func spec() {

        it("creates view controllers without blowing up") {
            _ = Factory.create(PlaceViewController.self)
            _ = Factory.create(PlaceDetailViewController.self)
            _ = Factory.create(PlaceSearchViewController.self)
        }

    }
}
