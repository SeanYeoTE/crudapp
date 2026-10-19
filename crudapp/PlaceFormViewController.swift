import UIKit

class PlaceFormViewController: UITableViewController {

    var place: Place?

    init(place: Place? = nil) {
        self.place = place
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = place == nil ? "New Place" : "Edit Place"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .cancel, 
            primaryAction: UIAction { [ weak self] _ in
            self?.dismiss(animated: true)
            }
        )
    }
}
