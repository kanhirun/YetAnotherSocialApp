import UIKit
import GoogleMaps
import GooglePlaces
import ContactsUI
import MessageUI
import ReactiveCocoa
import ReactiveSwift
import Result

final class PlaceViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    lazy var viewModel: PlaceViewModel = {
        return PlaceViewModel(
            places: PlaceService.shared,
            contacts: ContactService.shared,
            messages: MessageService.shared
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        placeTextField.delegate = self
        contactTextField.delegate = self

        placeTextField.reactive.text <~ viewModel.placeText
        contactTextField.reactive.text <~ viewModel.contactText
        sendButton.reactive.isEnabled <~ viewModel.sendButtonEnabled

        viewModel.placeSelected.startWithValues { camera in
            let updatedCamera = GMSCameraUpdate.setCamera(camera)

            self.mapView.moveCamera(updatedCamera)
        }

        viewModel.messageSent.startWithValues { marker, camera in
            marker.map = self.mapView
            self.mapView.camera = camera
        }
    }

    // MARK: - User Actions

    @IBAction func didTapSendButton() {
        guard MFMessageComposeViewController.canSendText() else {
            debugPrint("Cannot send text.")
            return
        }

        present(messageViewController(), animated: true, completion: nil)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == placeTextField {
            let placeSearchVC = Factory.create(PlaceSearchViewController.self)

            present(placeSearchVC, animated: true, completion: nil)
        } else if (textField == contactTextField) {
            let contactPickerVC = CNContactPickerViewController()
            contactPickerVC.delegate = viewModel

            present(contactPickerVC, animated: true, completion: nil)
        }

        return false
    }

    // MARK: - Helpers

    private func messageViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = viewModel
        messageComposeVC.recipients = viewModel.messageRecipient
        messageComposeVC.body = viewModel.messageBody

        return messageComposeVC
    }
}
