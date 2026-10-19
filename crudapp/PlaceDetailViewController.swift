import UIKit

class PlaceDetailViewController: UITableViewController {
    
    var place: Place
    
    private enum Section: Int, CaseIterable {
        case overview, details, notes
        
        var title: String {
            switch self {
            case .overview: return "Overview"
            case .details: return "Details"
            case .notes: return "Notes"
            }
        }
    }
    
    private struct Row {
        let label: String
        let value: String
    }
    
    private func rows(in section: Section) -> [Row] {
        switch section {
        case .overview:
            return [
                Row(label: "Name", value: place.name),
                Row(label: "Category", value: place.category.rawValue)
            ]
        case .details:
            return [
                Row(label: "Rating", value: String(format: "★ %.1f", place.rating)),
                Row(label: "Price", value: place.priceString),
                Row(label: "Last Visited", value: place.lastVisited.formatted(date: .long, time: .omitted))
            ]
        case .notes:
            return [Row(label: "", value: place.notes.isEmpty ? "No notes yet" : place.notes)]
        }
    }
    
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .edit,
            primaryAction: UIAction { [ weak self ] _ in
                guard let self else { return }
                let formVC = PlaceFormViewController(place: self.place)
                self.present(UINavigationController(rootViewController: formVC), animated: true)
            }
        )
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return rows(in: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        guard let section = Section(rawValue: indexPath.section) else { return cell }
        let row = rows(in: section)[indexPath.row]
        
        if section == .notes {
            var content = cell.defaultContentConfiguration()
            content.text = row.value
            content.textProperties.numberOfLines = 0
            if place.notes.isEmpty {
                content.textProperties.color = .secondaryLabel
            }
            cell.contentConfiguration = content
        } else {
            var content = UIListContentConfiguration.valueCell()
            content.text = row.label
            content.secondaryText = row.value
            cell.contentConfiguration = content
        }
        return cell
        
    }
}
