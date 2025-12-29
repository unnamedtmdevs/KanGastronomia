//
//  Restaurant.swift
//  Gastronomia
//

import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let cuisine: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phone: String?
    let website: String?
    let rating: Double
    let priceLevel: PriceLevel
    let imageURL: String?
    let menuItems: [MenuItem]
    let openingHours: [String]
    
    init(id: UUID = UUID(), name: String, description: String, cuisine: String, address: String, latitude: Double, longitude: Double, phone: String? = nil, website: String? = nil, rating: Double, priceLevel: PriceLevel, imageURL: String? = nil, menuItems: [MenuItem] = [], openingHours: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.cuisine = cuisine
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.website = website
        self.rating = rating
        self.priceLevel = priceLevel
        self.imageURL = imageURL
        self.menuItems = menuItems
        self.openingHours = openingHours
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MenuItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let nutritionalInfo: NutritionalInfo?
    let dietaryPreferences: [DietaryPreference]
    let imageURL: String?
    
    init(id: UUID = UUID(), name: String, description: String, price: Double, nutritionalInfo: NutritionalInfo? = nil, dietaryPreferences: [DietaryPreference] = [], imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.nutritionalInfo = nutritionalInfo
        self.dietaryPreferences = dietaryPreferences
        self.imageURL = imageURL
    }
}

enum PriceLevel: String, Codable, CaseIterable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case luxury = "$$$$"
}

