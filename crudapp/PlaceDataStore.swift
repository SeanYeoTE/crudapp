//
//  PlaceDataStore.swift
//  crudapp
//
//  Created by Nicholas Lim on 23/10/26.
//

import Foundation

class PlaceDataStore {
    static let shared = PlaceDataStore()

    private(set) var places: [Place]

    private init() {
        if FileManager.default.fileExists(atPath: Self.fileURL.path) {
            places = PlaceDataStore.load()
        } else {
            places = Place.sampleData()
            try? save(places)
        }
    }

    private static var fileURL: URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return documentsPath.appendingPathComponent("places.json")
    }

    private static func load() -> [Place] {
        guard let data = try? Data(contentsOf: fileURL),
            let places = try? JSONDecoder().decode([Place].self, from: data)
        else {
            return []
        }
        return places
    }

    /// Writes `places` to disk. Throws on failure so callers can react.
    private func save(_ places: [Place]) throws {
        let data = try JSONEncoder().encode(places)
        try data.write(to: Self.fileURL, options: .atomic)
    }

    func addPlace(_ place: Place) throws {
        var updated = places
        updated.append(place)
        try save(updated)
        places = updated
    }

    func updatePlace(_ place: Place) throws {
        var updated = places
        guard let index = updated.firstIndex(where: { $0.id == place.id })
        else { return }
        updated[index] = place
        try save(updated)
        places = updated
    }

    func deletePlace(_ place: Place) throws {
        var updated = places
        updated.removeAll(where: { $0.id == place.id })
        try save(updated)
        places = updated
    }

    func deletePlace(at index: Int) throws {
        var updated = places
        updated.remove(at: index)
        try save(updated)
        places = updated
    }
}
