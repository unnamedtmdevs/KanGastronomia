//
//  Recipe.swift
//  Gastronomia
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let cuisine: String
    let preparationTime: Int // in minutes
    let cookingTime: Int // in minutes
    let difficulty: DifficultyLevel
    let servings: Int
    let imageURL: String?
    let ingredients: [Ingredient]
    let instructions: [String]
    let nutritionalInfo: NutritionalInfo
    let tags: [String]
    let dietaryPreferences: [DietaryPreference]
    
    init(id: UUID = UUID(), name: String, description: String, cuisine: String, preparationTime: Int, cookingTime: Int, difficulty: DifficultyLevel, servings: Int, imageURL: String? = nil, ingredients: [Ingredient], instructions: [String], nutritionalInfo: NutritionalInfo, tags: [String] = [], dietaryPreferences: [DietaryPreference] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.cuisine = cuisine
        self.preparationTime = preparationTime
        self.cookingTime = cookingTime
        self.difficulty = difficulty
        self.servings = servings
        self.imageURL = imageURL
        self.ingredients = ingredients
        self.instructions = instructions
        self.nutritionalInfo = nutritionalInfo
        self.tags = tags
        self.dietaryPreferences = dietaryPreferences
    }
    
    var totalTime: Int {
        preparationTime + cookingTime
    }
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    let name: String
    let amount: Double
    let unit: String
    
    init(id: UUID = UUID(), name: String, amount: Double, unit: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}

struct NutritionalInfo: Codable {
    let calories: Double
    let protein: Double // grams
    let carbohydrates: Double // grams
    let fat: Double // grams
    let fiber: Double // grams
    let sugar: Double // grams
    let sodium: Double // mg
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
}

enum DietaryPreference: String, Codable, CaseIterable {
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten-Free"
    case dairyFree = "Dairy-Free"
    case keto = "Keto"
    case paleo = "Paleo"
    case lowCarb = "Low-Carb"
    case highProtein = "High-Protein"
}

