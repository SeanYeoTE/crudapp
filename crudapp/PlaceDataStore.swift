//
//  PlaceDataStore.swift
//  crudapp
//
//  Created by Nicholas Lim on 23/10/26.
//

import Foundation

class PlaceDataStore {
    static let shared = PlaceDataStore()  // 1. singleton
    private var places: [Place] = []

    private init() {}

    private var fileURL: URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return documentsPath.appendingPathComponent("places.json")
    }

    func loadPlaces() -> [Place] {
        guard let data = try? Data(contentsOf: fileURL),
            let places = try? JSONDecoder().decode([Place].self, from: data)
        else {
            return []
        }
        return places
    }

    func savePlaces(_ places: [Place]) throws {
        // 2. try? without error handling
        let data = try JSONEncoder().encode(places)
        try data.write(to: fileURL)
    }

    func addPlace(_ place: Place) {
        places.append(place)
    }

    func updatePlace(_ place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places[index] = place  // replace old struct with new one
        }
    }

    func deletePlace(_ place: Place) {
        places.removeAll(where: { $0.id == place.id })
    }

    func deletePlace(at index: Int) {
        places.remove(at: index)
    }
}
