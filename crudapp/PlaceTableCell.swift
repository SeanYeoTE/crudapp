import UIKit

class PlaceTableCell: UITableViewCell {

    static let identifier = "PlaceTableCell"

    var place: Place?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with place: Place) {
        var content = defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = "\(place.category.rawValue) · \(place.priceString) · ★ \(place.rating)"
        content.image = UIImage(systemName: place.category.symbolName)
        contentConfiguration = content
        accessoryType = .disclosureIndicator
    }
}
