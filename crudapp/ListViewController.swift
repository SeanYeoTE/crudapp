//
//  ViewController.swift
//  crudapp
//
//  Created by Sean Yeo on 19/10/26.
//

import UIKit

class ListViewController: UITableViewController, PlaceDetailViewControllerDelegate {
    private let store = PlaceDataStore.shared
    private var places: [Place] { store.places }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Places"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [weak self] _ in
                let formVC = PlaceFormViewController()
                formVC.delegate = self
                self?.present(UINavigationController(rootViewController: formVC), animated: true)
            }
        )
        tableView.register(PlaceTableCell.self, forCellReuseIdentifier: PlaceTableCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }

    // MARK: - Delete

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try store.deletePlace(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Failed to delete place: \(error)")
            }
        }
    }
}

// MARK: - PlaceFormViewControllerDelegate

extension ListViewController: PlaceFormViewControllerDelegate {
    func didAddPlace(_ place: Place) {
        do {
            try store.addPlace(place)
            tableView.reloadData()
        } catch {
            print("Failed to add place: \(error)")
        }
    }

    func didUpdatePlace(_ place: Place) {
        do {
            try store.updatePlace(place)
            tableView.reloadData()
        } catch {
            print("Failed to update place: \(error)")
        }
    }
}




#Preview {
    UINavigationController(rootViewController: ListViewController())
}

