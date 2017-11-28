import UIKit
@testable import YetAnotherSocialApp

final class TestFactory {

    static let window = UIWindow()

    static func create(_ placeVC: PlaceViewController.Type,
                       selectedPlaces: PlaceService,
                       selectedContacts: ContactService,
                       sentMessages: MessageService) -> PlaceViewController {

        let controller = Factory.create(placeVC)

        controller.viewModel = PlaceViewModel(
            places: selectedPlaces,
            contacts: selectedContacts,
            messages: sentMessages
        )

        window.rootViewController = controller
        window.makeKeyAndVisible()

        return controller
    }
}

