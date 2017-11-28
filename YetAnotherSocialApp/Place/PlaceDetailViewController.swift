import UIKit
import ReactiveSwift

final class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    private let placeService = PlaceService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let place = placeService.latest.value else {
            return
        }

        self.nameLabel.text = place.name
        self.addressLabel.text = place.address
        self.imageView.reactive.image <~ placeService.fetchImage(for: place)
    }
}
