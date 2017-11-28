import GooglePlaces
import XCTest

final class FakePlacesClient: GMSPlacesClient {

    var placeID: String?
    var metadata: GMSPlacePhotoMetadataList? = nil
    var metadataError: NSError? = nil

    override func lookUpPhotos(forPlaceID placeID: String, callback: @escaping GMSPlacePhotoMetadataResultCallback) {
        self.placeID = placeID
        callback(metadata, metadataError)
    }

    var photo: GMSPlacePhotoMetadata?
    var image: UIImage? = nil
    var imageError: NSError? = nil

    override func loadPlacePhoto(_ photo: GMSPlacePhotoMetadata, callback: @escaping GMSPlacePhotoImageResultCallback) {
        self.photo = photo

        callback(image, imageError)
    }

}
