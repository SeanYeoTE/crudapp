import Foundation
import CoreLocation

/// The kind of place. Backed by String so it's easy to display and (later) encode.
enum PlaceCategory: String, CaseIterable, Codable {
    case restaurant = "Restaurant"
    case cafe = "Café"
    case bakery = "Bakery"
    case hawker = "Hawker Stall"
    case bar = "Bar"

    /// SF Symbol name used in the list cell.
    var symbolName: String {
        switch self {
        case .restaurant: return "fork.knife"
        case .cafe:       return "cup.and.saucer.fill"
        case .bakery:     return "birthday.cake.fill"
        case .hawker:     return "takeoutbag.and.cup.and.straw.fill"
        case .bar:        return "wineglass.fill"
        }
    }
}

private struct StoredCoordinate: Codable {
    let latitude: Double
    let longitude: Double
}

/// The "Item" for this CRUD app.
/// A class (reference type) so that every screen editing a Place
/// mutates the same instance — pass by reference.
struct Place: Identifiable, Codable {
    let id: UUID
    var name: String              // String
    var category: PlaceCategory   // enum
    var rating: Double            // number (0.0 – 5.0)
    var priceLevel: Int           // number (1 – 4, i.e. $ to $$$$)
    var lastVisited: Date         // Date
    var notes: String
    var coordinate: CLLocationCoordinate2D?
    
    /// "$$" style string for display.
    var priceString: String {
        String(repeating: "$", count: priceLevel)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, category, rating, priceLevel, lastVisited, notes, coordinate
    }

    init(id: UUID = UUID(),
         name: String,
         category: PlaceCategory,
         rating: Double,
         priceLevel: Int,
         lastVisited: Date,
         notes: String = "",
         coordinate: CLLocationCoordinate2D? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.rating = min(max(rating, 0), 5)
        self.priceLevel = min(max(priceLevel, 1), 4)
        self.lastVisited = lastVisited
        self.notes = notes
        self.coordinate = coordinate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(PlaceCategory.self, forKey: .category)
        rating = try container.decode(Double.self, forKey: .rating)
        priceLevel = try container.decode(Int.self, forKey: .priceLevel)
        lastVisited = try container.decode(Date.self, forKey: .lastVisited)
        notes = try container.decode(String.self, forKey: .notes)

        let stored = try container.decodeIfPresent(StoredCoordinate.self, forKey: .coordinate)
        coordinate = stored.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(rating, forKey: .rating)
        try container.encode(priceLevel, forKey: .priceLevel)
        try container.encode(lastVisited, forKey: .lastVisited)
        try container.encode(notes, forKey: .notes)

        let stored = coordinate.map { StoredCoordinate(latitude: $0.latitude, longitude: $0.longitude) }
        try container.encodeIfPresent(stored, forKey: .coordinate)
    }
}

extension Place {
    /// In-memory seed data (no persistence in Part 1).
    static func sampleData() -> [Place] {
        let day: TimeInterval = 60 * 60 * 24
        let now = Date()
        return [
            Place(name: "Tiong Bahru Bakery", category: .bakery, rating: 4.5, priceLevel: 2,
                  lastVisited: now.addingTimeInterval(-3 * day), notes: "Kouign-amann is a must.",
                  coordinate: .init(latitude: 1.2847, longitude: 103.8327)),
            Place(name: "Common Man Coffee", category: .cafe, rating: 4.3, priceLevel: 2,
                  lastVisited: now.addingTimeInterval(-10 * day),
                  coordinate: .init(latitude: 1.2905, longitude: 103.8404)),
            Place(name: "Maxwell Chicken Rice", category: .hawker, rating: 4.7, priceLevel: 1,
                  lastVisited: now.addingTimeInterval(-1 * day), notes: "Go before 11am.",
                  coordinate: .init(latitude: 1.2803, longitude: 103.8448)),
            Place(name: "Burnt Ends", category: .restaurant, rating: 4.8, priceLevel: 4,
                  lastVisited: now.addingTimeInterval(-45 * day),
                  coordinate: .init(latitude: 1.3051, longitude: 103.8105)),
            Place(name: "Native", category: .bar, rating: 4.4, priceLevel: 3,
                  lastVisited: now.addingTimeInterval(-20 * day),
                  coordinate: .init(latitude: 1.2812, longitude: 103.8478))
        ]
    }
}
