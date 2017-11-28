import CoreLocation
@testable import YetAnotherSocialApp

extension Place {
    static func build(name: String = "some-place-name",
                      address: String = "some-address",
                      coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 99, longitude: 11),
                      placeID: String? = nil) -> Place {
        return Place(name: name, address: address, coordinate: coordinate, placeID: placeID)
    }
}
