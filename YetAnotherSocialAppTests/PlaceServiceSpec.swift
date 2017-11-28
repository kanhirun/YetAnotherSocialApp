import Quick
import Nimble
import Result

@testable import YetAnotherSocialApp
import GooglePlaces

final class PlaceServiceSpec: QuickSpec {
    override func spec() {

        var service: PlaceService!

        var client: FakePlacesClient!

        beforeEach {
            client = FakePlacesClient()
            service = PlaceService(client: client)
        }

        describe("shared") {
            it("returns a singleton") {
                expect(PlaceService.shared) == PlaceService.shared
                expect(PlaceService(client: client)) != PlaceService(client: client)
            }
        }

        describe("fetchImage(for place:)") {
            it("sends nil if the place doesn't have an id which points to a photo repository") {
                let placeWithoutID = Place.build(placeID: nil)

                let fetched = service.fetchImage(for: placeWithoutID)

                var value: UIImage?
                fetched.startWithValues {
                    value = $0
                }
                expect(value).to(beNil())
            }

            xcontext("when a photo exists for the place") {
                beforeEach {
                    client = FakePlacesClient()
                    service = PlaceService(client: client)
                }

                xit("sends an image") {
                    let placeWithID = Place.build(placeID: "some-existing-id")

                    let fetched = service.fetchImage(for: placeWithID)

                    var value: UIImage?
                    var completed = false
                    fetched.startWithValues {
                        value = $0
                    }
                    fetched.startWithCompleted {
                        completed = true
                    }
                    expect(value).to(beAnInstanceOf(UIImage.self))
                    expect(completed) == true
                    expect(client.placeID) == "some-existing-id"
                }
            }
        }
    }
}
