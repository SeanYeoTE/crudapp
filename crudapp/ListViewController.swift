//
//  ViewController.swift
//  crudapp
//
//  Created by Sean Yeo on 19/10/26.
//

import UIKit

class ListViewController: UITableViewController, PlaceDetailViewControllerDelegate {
    nonisolated enum Section: Hashable { case main }

    private let store = PlaceDataStore.shared
    private var places: [Place] { store.places }
    private var dataSource: UITableViewDiffableDataSource<Section, Place>!
    typealias DataSource = UITableViewDiffableDataSource<Section, Place>

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

        dataSource = UITableViewDiffableDataSource<Section, Place>( tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaceTableCell.identifier,
                for: indexPath
            ) as? PlaceTableCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }

        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot(animatingDifferences: false)
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Place>()
        snapshot.appendSections([.main])
        snapshot.appendItems(places, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard let place = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _,_,done in
            do {
                try self.store.deletePlace(place)
                self.applySnapshot()
            } catch {
                print("Failed to delete place: \(error)")
            }
            done(true)
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - PlaceFormViewControllerDelegate

extension ListViewController: PlaceFormViewControllerDelegate {
    func didAddPlace(_ place: Place) {
        do {
            try store.addPlace(place)
            applySnapshot()
        } catch {
            print("Failed to add place: \(error)")
        }
    }

    func didUpdatePlace(_ place: Place) {
        do {
            try store.updatePlace(place)
            applySnapshot()
        } catch {
            print("Failed to update place: \(error)")
        }
    }
}




#Preview {
    UINavigationController(rootViewController: ListViewController())
}

