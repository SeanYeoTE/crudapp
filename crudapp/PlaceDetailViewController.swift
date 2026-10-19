import UIKit

class PlaceDetailViewController: UITableViewController {

    var place: Place

    init(place: Place) {
        self.place = place
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = place.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .edit,
            primaryAction: UIAction { [ weak self ] _ in 
                guard let self else { return }
                let formVC = PlaceFormViewController(place: self.place)
                self.navigationController?.pushViewController(formVC, animated: true)
            }
        )
    }
}
