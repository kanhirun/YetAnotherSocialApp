import GoogleMaps
import GooglePlaces
import ReactiveSwift
import Result

struct Place {
    let name: String
    let address: String?
    let coordinate: CLLocationCoordinate2D

    // This id belongs to Google's systems (used by GMSPlacesClient)
    fileprivate let placeID: String?

    init(_ other: GMSPlace) {
        self.name = other.name
        self.coordinate = other.coordinate
        self.address = other.formattedAddress
        self.placeID = other.placeID
    }

    init(name: String, address: String?, coordinate: CLLocationCoordinate2D, placeID: String?) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.placeID = placeID
    }
}

final class PlaceService: NSObject {

    static let shared = PlaceService(client: GMSPlacesClient.shared())

    // The names of the places selected by the user
    let names: SignalProducer<String?, NoError>

    // Some components for updating the map
    let mapComponents: SignalProducer<(Place, GMSMarker, GMSCameraPosition), NoError>

    // The latest place selected by the user
    let latest = MutableProperty<Place?>(nil)

    private let client: GMSPlacesClient

    init(client: GMSPlacesClient) {
        self.client = client
        self.names = latest.producer.map { $0?.name }

        self.mapComponents = latest.producer
            .skipNil()
            .map { place -> (Place, GMSMarker, GMSCameraPosition) in
                let marker = GMSMarker(position: place.coordinate)
                let camera = GMSCameraPosition(target: place.coordinate, zoom: 17, bearing: 270, viewingAngle: 45)

                return (place, marker, camera)
            }

        super.init()
    }

    func fetchImage(for place: Place) -> SignalProducer<UIImage?, NoError> {
        guard let placeID = place.placeID else {
            return SignalProducer(value: nil)
        }

        return SignalProducer { observer, _ in
            self.client.lookUpPhotos(forPlaceID: placeID) { metadata, _ in
                guard let metadatum = metadata?.results[0] else {
                    observer.send(value: nil)
                    observer.sendCompleted()
                    return
                }

                self.client.loadPlacePhoto(metadatum) { image, _ in
                    observer.send(value: image)
                    observer.sendCompleted()
                }
            }
        }
    }
}

extension PlaceService {

    // Starts third party services and provides our API key
    // warning: - this should be called when the application is launched
    static func start() {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as! String

        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }

}

extension PlaceService: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.latest.value = Place(place)

        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {}

}


