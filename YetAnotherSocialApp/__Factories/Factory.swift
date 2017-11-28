import UIKit
import GooglePlaces

final class Factory {
    static func create(_ placeVC: PlaceViewController.Type) -> PlaceViewController {
        let navigation = UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController() as! UINavigationController

        return navigation.topViewController as! PlaceViewController
    }

    static func create(_ placeDetailVC: PlaceDetailViewController.Type) -> PlaceDetailViewController {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
    }

    static func create(_ placeSearch: PlaceSearchViewController.Type) -> PlaceSearchViewController {
        let controller = PlaceSearchViewController()

        controller.delegate = PlaceService.shared

        return controller
    }
}
