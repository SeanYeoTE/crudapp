//
//  ViewController.swift
//  crudapp
//
//  Created by Sean Yeo on 19/10/26.
//

import UIKit

class ListViewController: UITableViewController {

    private var places: [Place] = Place.sampleData()
    private let cellid = "PlaceCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Places"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let place = places[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = place.name
        content.secondaryText = "\(place.category.rawValue) · \(place.priceString) · ★ \(place.rating)"
        content.image = UIImage(systemName: place.category.symbolName)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}


#Preview {
    UINavigationController(rootViewController: ListViewController())
}

