//
//  MealPlan.swift
//  Gastronomia
//

import Foundation

struct MealPlan: Identifiable, Codable {
    let id: UUID
    let name: String
    let startDate: Date
    let endDate: Date
    let meals: [PlannedMeal]
    
    init(id: UUID = UUID(), name: String, startDate: Date, endDate: Date, meals: [PlannedMeal] = []) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.meals = meals
    }
    
    var shoppingList: [ShoppingItem] {
        var items: [String: ShoppingItem] = [:]
        
        for meal in meals {
            for ingredient in meal.recipe.ingredients {
                let key = ingredient.name.lowercased()
                if let existing = items[key] {
                    items[key] = ShoppingItem(
                        id: existing.id,
                        name: ingredient.name,
                        amount: existing.amount + ingredient.amount,
                        unit: ingredient.unit,
                        isPurchased: existing.isPurchased
                    )
                } else {
                    items[key] = ShoppingItem(
                        name: ingredient.name,
                        amount: ingredient.amount,
                        unit: ingredient.unit
                    )
                }
            }
        }
        
        return Array(items.values).sorted { $0.name < $1.name }
    }
}

struct PlannedMeal: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mealType: MealType
    let recipe: Recipe
    
    init(id: UUID = UUID(), date: Date, mealType: MealType, recipe: Recipe) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.recipe = recipe
    }
}

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let amount: Double
    let unit: String
    var isPurchased: Bool
    
    init(id: UUID = UUID(), name: String, amount: Double, unit: String, isPurchased: Bool = false) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
        self.isPurchased = isPurchased
    }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

