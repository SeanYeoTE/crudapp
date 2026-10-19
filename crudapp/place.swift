import Foundation

/// The kind of place. Backed by String so it's easy to display and (later) encode.
enum PlaceCategory: String, CaseIterable {
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

/// The "Item" for this CRUD app.
/// A class (reference type) so that every screen editing a Place
/// mutates the same instance — pass by reference.
class Place {
    let id: UUID
    var name: String              // String
    var category: PlaceCategory   // enum
    var rating: Double            // number (0.0 – 5.0)
    var priceLevel: Int           // number (1 – 4, i.e. $ to $$$$)
    var lastVisited: Date         // Date
    var notes: String

    init(id: UUID = UUID(),
         name: String,
         category: PlaceCategory,
         rating: Double,
         priceLevel: Int,
         lastVisited: Date,
         notes: String = "") {
        self.id = id
        self.name = name
        self.category = category
        self.rating = min(max(rating, 0), 5)
        self.priceLevel = min(max(priceLevel, 1), 4)
        self.lastVisited = lastVisited
        self.notes = notes
    }

    /// "$$" style string for display.
    var priceString: String {
        String(repeating: "$", count: priceLevel)
    }
}

extension Place {
    /// In-memory seed data (no persistence in Part 1).
    static func sampleData() -> [Place] {
        let day: TimeInterval = 60 * 60 * 24
        let now = Date()
        return [
            Place(name: "Tiong Bahru Bakery", category: .bakery, rating: 4.5, priceLevel: 2,
                  lastVisited: now.addingTimeInterval(-3 * day), notes: "Kouign-amann is a must."),
            Place(name: "Common Man Coffee", category: .cafe, rating: 4.3, priceLevel: 2,
                  lastVisited: now.addingTimeInterval(-10 * day)),
            Place(name: "Maxwell Chicken Rice", category: .hawker, rating: 4.7, priceLevel: 1,
                  lastVisited: now.addingTimeInterval(-1 * day), notes: "Go before 11am."),
            Place(name: "Burnt Ends", category: .restaurant, rating: 4.8, priceLevel: 4,
                  lastVisited: now.addingTimeInterval(-45 * day)),
            Place(name: "Native", category: .bar, rating: 4.4, priceLevel: 3,
                  lastVisited: now.addingTimeInterval(-20 * day))
        ]
    }
}