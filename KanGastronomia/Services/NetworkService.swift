//
//  NetworkService.swift
//  Gastronomia
//

import Foundation
import CoreLocation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    // Mock data for demonstration - in production, this would fetch from a real API
    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let recipes = self.generateMockRecipes()
            DispatchQueue.main.async {
                completion(.success(recipes))
            }
        }
    }
    
    func searchRecipes(query: String, dietaryPreferences: [DietaryPreference] = [], completion: @escaping (Result<[Recipe], Error>) -> Void) {
        fetchRecipes { result in
            switch result {
            case .success(let recipes):
                let filtered = recipes.filter { recipe in
                    let matchesQuery = query.isEmpty || recipe.name.localizedCaseInsensitiveContains(query) || recipe.cuisine.localizedCaseInsensitiveContains(query)
                    let matchesDiet = dietaryPreferences.isEmpty || !Set(recipe.dietaryPreferences).isDisjoint(with: Set(dietaryPreferences))
                    return matchesQuery && matchesDiet
                }
                completion(.success(filtered))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRestaurants(near location: CLLocationCoordinate2D, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let restaurants = self.generateMockRestaurants(near: location)
            DispatchQueue.main.async {
                completion(.success(restaurants))
            }
        }
    }
    
    // MARK: - Mock Data Generation
    
    private func generateMockRecipes() -> [Recipe] {
        return [
            Recipe(
                name: "Grilled Salmon with Quinoa",
                description: "Perfectly grilled salmon served with fluffy quinoa and roasted vegetables",
                cuisine: "Mediterranean",
                preparationTime: 15,
                cookingTime: 25,
                difficulty: .medium,
                servings: 2,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Salmon fillet", amount: 300, unit: "g"),
                    Ingredient(name: "Quinoa", amount: 1, unit: "cup"),
                    Ingredient(name: "Broccoli", amount: 200, unit: "g"),
                    Ingredient(name: "Olive oil", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Lemon", amount: 1, unit: "piece")
                ],
                instructions: [
                    "Rinse quinoa and cook according to package directions",
                    "Season salmon with salt, pepper, and lemon juice",
                    "Heat olive oil in a pan over medium-high heat",
                    "Grill salmon for 4-5 minutes on each side",
                    "Steam broccoli until tender",
                    "Serve salmon over quinoa with broccoli on the side"
                ],
                nutritionalInfo: NutritionalInfo(calories: 520, protein: 42, carbohydrates: 45, fat: 18, fiber: 8, sugar: 3, sodium: 340),
                tags: ["Healthy", "Quick", "Dinner"],
                dietaryPreferences: [.glutenFree, .highProtein]
            ),
            Recipe(
                name: "Buddha Bowl",
                description: "A colorful and nutritious vegan bowl with roasted chickpeas, avocado, and tahini dressing",
                cuisine: "International",
                preparationTime: 20,
                cookingTime: 30,
                difficulty: .easy,
                servings: 2,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Chickpeas", amount: 400, unit: "g"),
                    Ingredient(name: "Sweet potato", amount: 1, unit: "large"),
                    Ingredient(name: "Avocado", amount: 1, unit: "piece"),
                    Ingredient(name: "Kale", amount: 100, unit: "g"),
                    Ingredient(name: "Tahini", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Lemon juice", amount: 2, unit: "tbsp")
                ],
                instructions: [
                    "Preheat oven to 400°F (200°C)",
                    "Cube sweet potato and toss with olive oil, salt, and pepper",
                    "Drain and rinse chickpeas, toss with spices",
                    "Roast sweet potato and chickpeas for 25-30 minutes",
                    "Massage kale with a bit of olive oil",
                    "Mix tahini with lemon juice and water to make dressing",
                    "Assemble bowls with kale, roasted veggies, chickpeas, and avocado",
                    "Drizzle with tahini dressing"
                ],
                nutritionalInfo: NutritionalInfo(calories: 480, protein: 16, carbohydrates: 58, fat: 22, fiber: 15, sugar: 10, sodium: 280),
                tags: ["Vegan", "Healthy", "Lunch"],
                dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
            ),
            Recipe(
                name: "Chicken Tikka Masala",
                description: "Creamy Indian curry with tender chicken pieces in a rich tomato-based sauce",
                cuisine: "Indian",
                preparationTime: 30,
                cookingTime: 40,
                difficulty: .medium,
                servings: 4,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Chicken breast", amount: 600, unit: "g"),
                    Ingredient(name: "Yogurt", amount: 200, unit: "ml"),
                    Ingredient(name: "Tomato sauce", amount: 400, unit: "ml"),
                    Ingredient(name: "Heavy cream", amount: 200, unit: "ml"),
                    Ingredient(name: "Onion", amount: 2, unit: "large"),
                    Ingredient(name: "Garlic", amount: 4, unit: "cloves"),
                    Ingredient(name: "Ginger", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Garam masala", amount: 2, unit: "tsp")
                ],
                instructions: [
                    "Marinate chicken in yogurt and spices for at least 30 minutes",
                    "Grill or pan-fry chicken until cooked through",
                    "Sauté onions, garlic, and ginger until fragrant",
                    "Add tomato sauce and spices, simmer for 15 minutes",
                    "Add cream and cooked chicken, simmer for 10 more minutes",
                    "Serve with rice or naan bread"
                ],
                nutritionalInfo: NutritionalInfo(calories: 420, protein: 38, carbohydrates: 18, fat: 22, fiber: 3, sugar: 10, sodium: 520),
                tags: ["Dinner", "Indian", "Spicy"],
                dietaryPreferences: [.glutenFree]
            ),
            Recipe(
                name: "Greek Salad",
                description: "Fresh Mediterranean salad with tomatoes, cucumber, feta cheese, and olives",
                cuisine: "Greek",
                preparationTime: 15,
                cookingTime: 0,
                difficulty: .easy,
                servings: 2,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Tomatoes", amount: 3, unit: "large"),
                    Ingredient(name: "Cucumber", amount: 1, unit: "large"),
                    Ingredient(name: "Red onion", amount: 0.5, unit: "piece"),
                    Ingredient(name: "Feta cheese", amount: 150, unit: "g"),
                    Ingredient(name: "Kalamata olives", amount: 100, unit: "g"),
                    Ingredient(name: "Olive oil", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Red wine vinegar", amount: 1, unit: "tbsp")
                ],
                instructions: [
                    "Chop tomatoes and cucumber into chunks",
                    "Thinly slice red onion",
                    "Combine vegetables in a large bowl",
                    "Add olives and crumbled feta cheese",
                    "Drizzle with olive oil and vinegar",
                    "Season with salt, pepper, and oregano",
                    "Toss gently and serve immediately"
                ],
                nutritionalInfo: NutritionalInfo(calories: 320, protein: 12, carbohydrates: 15, fat: 25, fiber: 4, sugar: 8, sodium: 680),
                tags: ["Salad", "Quick", "Lunch"],
                dietaryPreferences: [.vegetarian, .glutenFree, .lowCarb]
            ),
            Recipe(
                name: "Keto Avocado Egg Breakfast",
                description: "Low-carb breakfast with baked eggs in avocado halves",
                cuisine: "American",
                preparationTime: 5,
                cookingTime: 15,
                difficulty: .easy,
                servings: 2,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Avocados", amount: 2, unit: "large"),
                    Ingredient(name: "Eggs", amount: 4, unit: "piece"),
                    Ingredient(name: "Bacon", amount: 4, unit: "strips"),
                    Ingredient(name: "Cheddar cheese", amount: 50, unit: "g"),
                    Ingredient(name: "Salt", amount: 1, unit: "pinch"),
                    Ingredient(name: "Black pepper", amount: 1, unit: "pinch")
                ],
                instructions: [
                    "Preheat oven to 425°F (220°C)",
                    "Cut avocados in half and remove pits",
                    "Scoop out a bit more flesh to make room for eggs",
                    "Place avocado halves in a baking dish",
                    "Crack an egg into each avocado half",
                    "Season with salt and pepper",
                    "Bake for 15 minutes until eggs are set",
                    "Cook bacon until crispy",
                    "Top with cheese and crispy bacon"
                ],
                nutritionalInfo: NutritionalInfo(calories: 450, protein: 24, carbohydrates: 12, fat: 36, fiber: 7, sugar: 1, sodium: 520),
                tags: ["Breakfast", "Keto", "Low-Carb"],
                dietaryPreferences: [.keto, .lowCarb, .glutenFree]
            ),
            Recipe(
                name: "Pad Thai",
                description: "Classic Thai stir-fried rice noodles with shrimp, tofu, and peanuts",
                cuisine: "Thai",
                preparationTime: 25,
                cookingTime: 15,
                difficulty: .medium,
                servings: 3,
                imageURL: nil,
                ingredients: [
                    Ingredient(name: "Rice noodles", amount: 200, unit: "g"),
                    Ingredient(name: "Shrimp", amount: 200, unit: "g"),
                    Ingredient(name: "Tofu", amount: 150, unit: "g"),
                    Ingredient(name: "Eggs", amount: 2, unit: "piece"),
                    Ingredient(name: "Bean sprouts", amount: 100, unit: "g"),
                    Ingredient(name: "Peanuts", amount: 50, unit: "g"),
                    Ingredient(name: "Tamarind paste", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Fish sauce", amount: 2, unit: "tbsp")
                ],
                instructions: [
                    "Soak rice noodles in warm water for 30 minutes",
                    "Prepare sauce by mixing tamarind paste, fish sauce, and sugar",
                    "Heat oil in a wok over high heat",
                    "Stir-fry shrimp and tofu until cooked",
                    "Push to the side and scramble eggs",
                    "Add drained noodles and sauce",
                    "Toss everything together",
                    "Add bean sprouts and cook for 1 minute",
                    "Serve topped with crushed peanuts and lime wedges"
                ],
                nutritionalInfo: NutritionalInfo(calories: 520, protein: 28, carbohydrates: 62, fat: 16, fiber: 4, sugar: 8, sodium: 920),
                tags: ["Asian", "Dinner", "Spicy"],
                dietaryPreferences: [.glutenFree]
            )
        ]
    }
    
    private func generateMockRestaurants(near location: CLLocationCoordinate2D) -> [Restaurant] {
        let baseLatitude = location.latitude
        let baseLongitude = location.longitude
        
        return [
            Restaurant(
                name: "The Green Kitchen",
                description: "Farm-to-table restaurant specializing in organic, locally-sourced ingredients",
                cuisine: "Contemporary",
                address: "123 Main Street",
                latitude: baseLatitude + 0.001,
                longitude: baseLongitude + 0.001,
                phone: "+1 (555) 123-4567",
                website: "https://thegreenkitchen.example.com",
                rating: 4.7,
                priceLevel: .moderate,
                imageURL: nil,
                menuItems: [
                    MenuItem(
                        name: "Quinoa Power Bowl",
                        description: "Mixed greens, roasted vegetables, and tahini dressing",
                        price: 14.99,
                        nutritionalInfo: NutritionalInfo(calories: 420, protein: 14, carbohydrates: 52, fat: 18, fiber: 12, sugar: 8, sodium: 340),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    ),
                    MenuItem(
                        name: "Grilled Chicken Salad",
                        description: "Free-range chicken breast with seasonal greens",
                        price: 16.99,
                        nutritionalInfo: NutritionalInfo(calories: 380, protein: 42, carbohydrates: 15, fat: 16, fiber: 6, sugar: 5, sodium: 420),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    )
                ],
                openingHours: ["Mon-Fri: 11:00 AM - 10:00 PM", "Sat-Sun: 10:00 AM - 11:00 PM"]
            ),
            Restaurant(
                name: "Spice Route",
                description: "Authentic Indian cuisine with a modern twist",
                cuisine: "Indian",
                address: "456 Oak Avenue",
                latitude: baseLatitude - 0.002,
                longitude: baseLongitude + 0.003,
                phone: "+1 (555) 234-5678",
                website: "https://spiceroute.example.com",
                rating: 4.5,
                priceLevel: .moderate,
                imageURL: nil,
                menuItems: [
                    MenuItem(
                        name: "Vegetable Curry",
                        description: "Mixed vegetables in aromatic curry sauce",
                        price: 13.99,
                        nutritionalInfo: NutritionalInfo(calories: 340, protein: 10, carbohydrates: 45, fat: 14, fiber: 8, sugar: 12, sodium: 680),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    ),
                    MenuItem(
                        name: "Tandoori Chicken",
                        description: "Clay oven-roasted chicken with traditional spices",
                        price: 17.99,
                        nutritionalInfo: NutritionalInfo(calories: 420, protein: 48, carbohydrates: 8, fat: 20, fiber: 2, sugar: 4, sodium: 820),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    )
                ],
                openingHours: ["Daily: 12:00 PM - 10:00 PM"]
            ),
            Restaurant(
                name: "Mediterranean Breeze",
                description: "Fresh Mediterranean flavors in a cozy atmosphere",
                cuisine: "Mediterranean",
                address: "789 Elm Street",
                latitude: baseLatitude + 0.003,
                longitude: baseLongitude - 0.002,
                phone: "+1 (555) 345-6789",
                rating: 4.8,
                priceLevel: .expensive,
                imageURL: nil,
                menuItems: [
                    MenuItem(
                        name: "Grilled Sea Bass",
                        description: "Whole sea bass with lemon and herbs",
                        price: 28.99,
                        nutritionalInfo: NutritionalInfo(calories: 380, protein: 46, carbohydrates: 5, fat: 18, fiber: 1, sugar: 2, sodium: 420),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    ),
                    MenuItem(
                        name: "Falafel Platter",
                        description: "Crispy falafel with hummus and tabbouleh",
                        price: 15.99,
                        nutritionalInfo: NutritionalInfo(calories: 460, protein: 16, carbohydrates: 52, fat: 22, fiber: 12, sugar: 6, sodium: 680),
                        dietaryPreferences: [.vegan, .vegetarian]
                    )
                ],
                openingHours: ["Tue-Sun: 5:00 PM - 11:00 PM", "Closed Monday"]
            )
        ]
    }
}

