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
        tableView.register(PlaceTableCell.self, forCellReuseIdentifier: PlaceTableCell.identifier)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableCell.identifier, for: indexPath) as! PlaceTableCell
        cell.place = places[indexPath.row]
        return cell
    }

  // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PlaceDetailViewController(place: places[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }



}




#Preview {
    UINavigationController(rootViewController: ListViewController())
}

