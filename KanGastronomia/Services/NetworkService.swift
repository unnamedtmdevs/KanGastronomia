//
//  NetworkService.swift
//  Gastronomia
//

import Foundation
import CoreLocation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            let recipes = self.loadRecipeDatabase()
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            let restaurants = self.loadRestaurantDatabase(near: location)
            DispatchQueue.main.async {
                completion(.success(restaurants))
            }
        }
    }
    
    // MARK: - Recipe Database
    
    private func loadRecipeDatabase() -> [Recipe] {
        return [
            Recipe(
                name: "Grilled Salmon with Quinoa",
                description: "Perfectly grilled salmon served with fluffy quinoa and roasted vegetables",
                cuisine: "Mediterranean",
                preparationTime: 15,
                cookingTime: 25,
                difficulty: .medium,
                servings: 2,
                imageURL: "fish.fill",
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
                imageURL: "leaf.fill",
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
                imageURL: "flame.fill",
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
                imageURL: "leaf.circle.fill",
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
                imageURL: "sun.max.fill",
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
                imageURL: "fork.knife",
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
            ),
            Recipe(
                name: "Mushroom Risotto",
                description: "Creamy Italian risotto with wild mushrooms and parmesan",
                cuisine: "Italian",
                preparationTime: 10,
                cookingTime: 35,
                difficulty: .medium,
                servings: 4,
                imageURL: "circle.grid.cross.fill",
                ingredients: [
                    Ingredient(name: "Arborio rice", amount: 300, unit: "g"),
                    Ingredient(name: "Mixed mushrooms", amount: 400, unit: "g"),
                    Ingredient(name: "Vegetable broth", amount: 1000, unit: "ml"),
                    Ingredient(name: "White wine", amount: 150, unit: "ml"),
                    Ingredient(name: "Parmesan cheese", amount: 100, unit: "g"),
                    Ingredient(name: "Butter", amount: 50, unit: "g"),
                    Ingredient(name: "Shallots", amount: 2, unit: "pieces"),
                    Ingredient(name: "Garlic", amount: 3, unit: "cloves")
                ],
                instructions: [
                    "Heat broth in a saucepan and keep warm",
                    "Sauté chopped shallots and garlic in butter",
                    "Add sliced mushrooms and cook until golden",
                    "Add rice and toast for 2 minutes",
                    "Pour in wine and stir until absorbed",
                    "Add broth one ladle at a time, stirring constantly",
                    "Continue until rice is creamy and al dente (about 20 minutes)",
                    "Stir in parmesan and remaining butter",
                    "Season with salt and pepper, serve immediately"
                ],
                nutritionalInfo: NutritionalInfo(calories: 420, protein: 14, carbohydrates: 62, fat: 14, fiber: 3, sugar: 2, sodium: 680),
                tags: ["Italian", "Comfort Food", "Dinner"],
                dietaryPreferences: [.vegetarian, .glutenFree]
            ),
            Recipe(
                name: "Beef Tacos",
                description: "Spicy ground beef tacos with fresh toppings and homemade guacamole",
                cuisine: "Mexican",
                preparationTime: 15,
                cookingTime: 20,
                difficulty: .easy,
                servings: 4,
                imageURL: "flame",
                ingredients: [
                    Ingredient(name: "Ground beef", amount: 500, unit: "g"),
                    Ingredient(name: "Taco shells", amount: 12, unit: "pieces"),
                    Ingredient(name: "Avocados", amount: 2, unit: "pieces"),
                    Ingredient(name: "Tomatoes", amount: 2, unit: "medium"),
                    Ingredient(name: "Lettuce", amount: 200, unit: "g"),
                    Ingredient(name: "Cheddar cheese", amount: 150, unit: "g"),
                    Ingredient(name: "Taco seasoning", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Sour cream", amount: 150, unit: "ml")
                ],
                instructions: [
                    "Brown ground beef in a large skillet",
                    "Add taco seasoning and water, simmer for 10 minutes",
                    "Warm taco shells in the oven",
                    "Prepare guacamole by mashing avocados with lime juice",
                    "Chop lettuce and tomatoes",
                    "Assemble tacos with beef, lettuce, tomatoes, and cheese",
                    "Top with guacamole and sour cream",
                    "Serve immediately with lime wedges"
                ],
                nutritionalInfo: NutritionalInfo(calories: 540, protein: 32, carbohydrates: 38, fat: 28, fiber: 6, sugar: 3, sodium: 820),
                tags: ["Mexican", "Quick", "Dinner"],
                dietaryPreferences: [.highProtein]
            ),
            Recipe(
                name: "Quinoa Stuffed Bell Peppers",
                description: "Colorful bell peppers stuffed with quinoa, black beans, and vegetables",
                cuisine: "Mediterranean",
                preparationTime: 20,
                cookingTime: 45,
                difficulty: .medium,
                servings: 4,
                imageURL: "square.stack.3d.up.fill",
                ingredients: [
                    Ingredient(name: "Bell peppers", amount: 4, unit: "large"),
                    Ingredient(name: "Quinoa", amount: 200, unit: "g"),
                    Ingredient(name: "Black beans", amount: 400, unit: "g"),
                    Ingredient(name: "Corn", amount: 200, unit: "g"),
                    Ingredient(name: "Tomatoes", amount: 300, unit: "g"),
                    Ingredient(name: "Onion", amount: 1, unit: "medium"),
                    Ingredient(name: "Garlic", amount: 3, unit: "cloves"),
                    Ingredient(name: "Cumin", amount: 1, unit: "tsp")
                ],
                instructions: [
                    "Preheat oven to 375°F (190°C)",
                    "Cook quinoa according to package instructions",
                    "Cut tops off peppers and remove seeds",
                    "Sauté onion and garlic until soft",
                    "Mix cooked quinoa with beans, corn, tomatoes, and spices",
                    "Stuff peppers with quinoa mixture",
                    "Place in baking dish with a bit of water",
                    "Bake for 35-40 minutes until peppers are tender",
                    "Top with cheese if desired and serve"
                ],
                nutritionalInfo: NutritionalInfo(calories: 340, protein: 14, carbohydrates: 58, fat: 6, fiber: 12, sugar: 10, sodium: 380),
                tags: ["Vegan", "Healthy", "Dinner"],
                dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
            ),
            Recipe(
                name: "Teriyaki Chicken Bowl",
                description: "Japanese-inspired bowl with teriyaki glazed chicken and steamed vegetables",
                cuisine: "Japanese",
                preparationTime: 15,
                cookingTime: 25,
                difficulty: .easy,
                servings: 3,
                imageURL: "bowl.fill",
                ingredients: [
                    Ingredient(name: "Chicken thighs", amount: 500, unit: "g"),
                    Ingredient(name: "Soy sauce", amount: 4, unit: "tbsp"),
                    Ingredient(name: "Mirin", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Brown sugar", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Rice", amount: 300, unit: "g"),
                    Ingredient(name: "Broccoli", amount: 200, unit: "g"),
                    Ingredient(name: "Carrots", amount: 2, unit: "medium"),
                    Ingredient(name: "Sesame seeds", amount: 1, unit: "tbsp")
                ],
                instructions: [
                    "Cook rice according to package instructions",
                    "Mix soy sauce, mirin, and sugar to make teriyaki sauce",
                    "Cut chicken into bite-sized pieces",
                    "Cook chicken in a hot pan until golden",
                    "Add teriyaki sauce and cook until glazed",
                    "Steam broccoli and carrots until tender",
                    "Assemble bowls with rice, chicken, and vegetables",
                    "Sprinkle with sesame seeds and serve"
                ],
                nutritionalInfo: NutritionalInfo(calories: 480, protein: 36, carbohydrates: 58, fat: 12, fiber: 4, sugar: 12, sodium: 940),
                tags: ["Japanese", "Bowl", "Dinner"],
                dietaryPreferences: [.highProtein]
            ),
            Recipe(
                name: "Caprese Salad",
                description: "Classic Italian salad with fresh mozzarella, tomatoes, and basil",
                cuisine: "Italian",
                preparationTime: 10,
                cookingTime: 0,
                difficulty: .easy,
                servings: 2,
                imageURL: "leaf.arrow.circlepath",
                ingredients: [
                    Ingredient(name: "Fresh mozzarella", amount: 250, unit: "g"),
                    Ingredient(name: "Tomatoes", amount: 3, unit: "large"),
                    Ingredient(name: "Fresh basil", amount: 20, unit: "leaves"),
                    Ingredient(name: "Extra virgin olive oil", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Balsamic vinegar", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Sea salt", amount: 1, unit: "tsp"),
                    Ingredient(name: "Black pepper", amount: 0.5, unit: "tsp")
                ],
                instructions: [
                    "Slice tomatoes and mozzarella into 1/4 inch rounds",
                    "Arrange alternating slices on a platter",
                    "Tuck fresh basil leaves between slices",
                    "Drizzle with olive oil and balsamic vinegar",
                    "Season with sea salt and freshly ground black pepper",
                    "Let sit for 10 minutes before serving",
                    "Serve at room temperature"
                ],
                nutritionalInfo: NutritionalInfo(calories: 280, protein: 18, carbohydrates: 10, fat: 20, fiber: 2, sugar: 6, sodium: 520),
                tags: ["Italian", "Salad", "Quick"],
                dietaryPreferences: [.vegetarian, .glutenFree, .lowCarb]
            ),
            Recipe(
                name: "Lentil Soup",
                description: "Hearty and nutritious lentil soup with vegetables and Mediterranean spices",
                cuisine: "Mediterranean",
                preparationTime: 15,
                cookingTime: 40,
                difficulty: .easy,
                servings: 6,
                imageURL: "drop.fill",
                ingredients: [
                    Ingredient(name: "Red lentils", amount: 300, unit: "g"),
                    Ingredient(name: "Vegetable broth", amount: 1500, unit: "ml"),
                    Ingredient(name: "Carrots", amount: 3, unit: "medium"),
                    Ingredient(name: "Celery", amount: 3, unit: "stalks"),
                    Ingredient(name: "Onion", amount: 1, unit: "large"),
                    Ingredient(name: "Garlic", amount: 4, unit: "cloves"),
                    Ingredient(name: "Cumin", amount: 1, unit: "tsp"),
                    Ingredient(name: "Lemon juice", amount: 2, unit: "tbsp")
                ],
                instructions: [
                    "Rinse lentils and set aside",
                    "Chop carrots, celery, and onion",
                    "Sauté vegetables in olive oil until soft",
                    "Add minced garlic and cumin, cook for 1 minute",
                    "Add lentils and vegetable broth",
                    "Bring to a boil, then reduce heat and simmer for 30 minutes",
                    "Blend partially for a creamy texture if desired",
                    "Stir in lemon juice and season with salt and pepper",
                    "Serve hot with crusty bread"
                ],
                nutritionalInfo: NutritionalInfo(calories: 240, protein: 14, carbohydrates: 42, fat: 2, fiber: 18, sugar: 6, sodium: 480),
                tags: ["Soup", "Healthy", "Vegan"],
                dietaryPreferences: [.vegan, .vegetarian, .glutenFree, .highProtein]
            ),
            Recipe(
                name: "Shrimp Scampi",
                description: "Garlicky shrimp in white wine butter sauce over linguine",
                cuisine: "Italian",
                preparationTime: 10,
                cookingTime: 15,
                difficulty: .easy,
                servings: 4,
                imageURL: "sparkles",
                ingredients: [
                    Ingredient(name: "Large shrimp", amount: 600, unit: "g"),
                    Ingredient(name: "Linguine", amount: 400, unit: "g"),
                    Ingredient(name: "Garlic", amount: 6, unit: "cloves"),
                    Ingredient(name: "White wine", amount: 150, unit: "ml"),
                    Ingredient(name: "Butter", amount: 60, unit: "g"),
                    Ingredient(name: "Olive oil", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Lemon", amount: 1, unit: "piece"),
                    Ingredient(name: "Parsley", amount: 4, unit: "tbsp")
                ],
                instructions: [
                    "Cook linguine according to package directions",
                    "Peel and devein shrimp if needed",
                    "Heat olive oil and butter in a large pan",
                    "Add minced garlic and cook until fragrant",
                    "Add shrimp and cook until pink (about 3 minutes)",
                    "Pour in white wine and lemon juice",
                    "Simmer for 2-3 minutes until sauce reduces slightly",
                    "Toss with cooked linguine and chopped parsley",
                    "Serve immediately with lemon wedges"
                ],
                nutritionalInfo: NutritionalInfo(calories: 520, protein: 38, carbohydrates: 48, fat: 18, fiber: 2, sugar: 2, sodium: 640),
                tags: ["Italian", "Seafood", "Dinner"],
                dietaryPreferences: [.highProtein]
            ),
            Recipe(
                name: "Vegetable Stir-Fry",
                description: "Colorful mix of fresh vegetables in savory Asian sauce",
                cuisine: "Chinese",
                preparationTime: 20,
                cookingTime: 10,
                difficulty: .easy,
                servings: 4,
                imageURL: "wand.and.stars",
                ingredients: [
                    Ingredient(name: "Broccoli", amount: 200, unit: "g"),
                    Ingredient(name: "Bell peppers", amount: 2, unit: "medium"),
                    Ingredient(name: "Snap peas", amount: 150, unit: "g"),
                    Ingredient(name: "Carrots", amount: 2, unit: "medium"),
                    Ingredient(name: "Mushrooms", amount: 200, unit: "g"),
                    Ingredient(name: "Soy sauce", amount: 4, unit: "tbsp"),
                    Ingredient(name: "Ginger", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Sesame oil", amount: 2, unit: "tbsp")
                ],
                instructions: [
                    "Cut all vegetables into bite-sized pieces",
                    "Mix soy sauce, ginger, and sesame oil for sauce",
                    "Heat wok or large pan over high heat",
                    "Add oil and swirl to coat",
                    "Stir-fry carrots and broccoli for 3 minutes",
                    "Add remaining vegetables and stir-fry for 3-4 minutes",
                    "Pour in sauce and toss to coat",
                    "Cook for 1-2 more minutes until vegetables are tender-crisp",
                    "Serve over rice or noodles"
                ],
                nutritionalInfo: NutritionalInfo(calories: 180, protein: 8, carbohydrates: 24, fat: 7, fiber: 6, sugar: 10, sodium: 640),
                tags: ["Vegan", "Quick", "Healthy"],
                dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
            ),
            Recipe(
                name: "Chocolate Protein Smoothie Bowl",
                description: "Rich chocolate smoothie bowl topped with fresh fruits and nuts",
                cuisine: "American",
                preparationTime: 10,
                cookingTime: 0,
                difficulty: .easy,
                servings: 2,
                imageURL: "star.fill",
                ingredients: [
                    Ingredient(name: "Frozen bananas", amount: 2, unit: "medium"),
                    Ingredient(name: "Cocoa powder", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Protein powder", amount: 2, unit: "scoops"),
                    Ingredient(name: "Almond milk", amount: 200, unit: "ml"),
                    Ingredient(name: "Peanut butter", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Chia seeds", amount: 1, unit: "tbsp"),
                    Ingredient(name: "Berries", amount: 100, unit: "g"),
                    Ingredient(name: "Granola", amount: 50, unit: "g")
                ],
                instructions: [
                    "Add frozen bananas to blender",
                    "Add cocoa powder, protein powder, and peanut butter",
                    "Pour in almond milk",
                    "Blend until smooth and thick",
                    "Pour into bowls",
                    "Top with fresh berries, granola, and chia seeds",
                    "Add additional toppings as desired",
                    "Serve immediately"
                ],
                nutritionalInfo: NutritionalInfo(calories: 380, protein: 28, carbohydrates: 48, fat: 12, fiber: 10, sugar: 22, sodium: 180),
                tags: ["Breakfast", "Smoothie", "Healthy"],
                dietaryPreferences: [.vegetarian, .highProtein]
            ),
            Recipe(
                name: "Baked Cod with Herbs",
                description: "Flaky white fish baked with fresh herbs and lemon",
                cuisine: "Mediterranean",
                preparationTime: 10,
                cookingTime: 20,
                difficulty: .easy,
                servings: 2,
                imageURL: "fish.circle.fill",
                ingredients: [
                    Ingredient(name: "Cod fillets", amount: 400, unit: "g"),
                    Ingredient(name: "Cherry tomatoes", amount: 200, unit: "g"),
                    Ingredient(name: "Garlic", amount: 3, unit: "cloves"),
                    Ingredient(name: "Fresh parsley", amount: 4, unit: "tbsp"),
                    Ingredient(name: "Fresh thyme", amount: 2, unit: "tsp"),
                    Ingredient(name: "Lemon", amount: 1, unit: "piece"),
                    Ingredient(name: "Olive oil", amount: 3, unit: "tbsp"),
                    Ingredient(name: "White wine", amount: 50, unit: "ml")
                ],
                instructions: [
                    "Preheat oven to 400°F (200°C)",
                    "Place cod fillets in a baking dish",
                    "Surround with halved cherry tomatoes",
                    "Drizzle with olive oil and white wine",
                    "Add minced garlic, parsley, and thyme",
                    "Season with salt and pepper",
                    "Top with lemon slices",
                    "Bake for 15-20 minutes until fish flakes easily",
                    "Serve with crusty bread or rice"
                ],
                nutritionalInfo: NutritionalInfo(calories: 280, protein: 42, carbohydrates: 8, fat: 14, fiber: 2, sugar: 4, sodium: 380),
                tags: ["Seafood", "Healthy", "Dinner"],
                dietaryPreferences: [.glutenFree, .highProtein, .lowCarb]
            ),
            Recipe(
                name: "Sweet Potato & Black Bean Burrito",
                description: "Hearty vegetarian burrito filled with roasted sweet potato and black beans",
                cuisine: "Mexican",
                preparationTime: 15,
                cookingTime: 30,
                difficulty: .easy,
                servings: 4,
                imageURL: "shield.fill",
                ingredients: [
                    Ingredient(name: "Sweet potatoes", amount: 2, unit: "large"),
                    Ingredient(name: "Black beans", amount: 400, unit: "g"),
                    Ingredient(name: "Tortillas", amount: 4, unit: "large"),
                    Ingredient(name: "Avocado", amount: 1, unit: "piece"),
                    Ingredient(name: "Cilantro", amount: 4, unit: "tbsp"),
                    Ingredient(name: "Lime", amount: 1, unit: "piece"),
                    Ingredient(name: "Cumin", amount: 1, unit: "tsp"),
                    Ingredient(name: "Salsa", amount: 150, unit: "ml")
                ],
                instructions: [
                    "Preheat oven to 425°F (220°C)",
                    "Cube sweet potatoes and toss with oil and cumin",
                    "Roast for 25-30 minutes until tender",
                    "Warm black beans with spices",
                    "Warm tortillas in a dry pan",
                    "Mash avocado with lime juice",
                    "Assemble burritos with sweet potato, beans, and avocado",
                    "Add cilantro and salsa",
                    "Roll tightly and serve"
                ],
                nutritionalInfo: NutritionalInfo(calories: 420, protein: 14, carbohydrates: 68, fat: 12, fiber: 14, sugar: 8, sodium: 580),
                tags: ["Mexican", "Vegetarian", "Lunch"],
                dietaryPreferences: [.vegan, .vegetarian]
            ),
            Recipe(
                name: "Miso Glazed Eggplant",
                description: "Japanese-style roasted eggplant with sweet miso glaze",
                cuisine: "Japanese",
                preparationTime: 10,
                cookingTime: 25,
                difficulty: .medium,
                servings: 2,
                imageURL: "moon.fill",
                ingredients: [
                    Ingredient(name: "Eggplants", amount: 2, unit: "medium"),
                    Ingredient(name: "White miso paste", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Mirin", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Sake", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Sugar", amount: 1, unit: "tbsp"),
                    Ingredient(name: "Sesame oil", amount: 1, unit: "tbsp"),
                    Ingredient(name: "Green onions", amount: 2, unit: "stalks"),
                    Ingredient(name: "Sesame seeds", amount: 1, unit: "tsp")
                ],
                instructions: [
                    "Preheat oven to 400°F (200°C)",
                    "Cut eggplants in half lengthwise",
                    "Score flesh in a crosshatch pattern",
                    "Brush with sesame oil",
                    "Roast for 20 minutes until tender",
                    "Mix miso, mirin, sake, and sugar for glaze",
                    "Brush glaze over eggplant",
                    "Broil for 3-5 minutes until caramelized",
                    "Garnish with green onions and sesame seeds"
                ],
                nutritionalInfo: NutritionalInfo(calories: 220, protein: 6, carbohydrates: 32, fat: 8, fiber: 8, sugar: 18, sodium: 780),
                tags: ["Japanese", "Vegan", "Dinner"],
                dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
            ),
            Recipe(
                name: "Spinach & Feta Omelette",
                description: "Fluffy omelette filled with fresh spinach and crumbled feta cheese",
                cuisine: "Mediterranean",
                preparationTime: 5,
                cookingTime: 10,
                difficulty: .easy,
                servings: 1,
                imageURL: "sunrise",
                ingredients: [
                    Ingredient(name: "Eggs", amount: 3, unit: "large"),
                    Ingredient(name: "Fresh spinach", amount: 50, unit: "g"),
                    Ingredient(name: "Feta cheese", amount: 50, unit: "g"),
                    Ingredient(name: "Butter", amount: 1, unit: "tbsp"),
                    Ingredient(name: "Milk", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Cherry tomatoes", amount: 5, unit: "pieces"),
                    Ingredient(name: "Salt", amount: 0.5, unit: "tsp"),
                    Ingredient(name: "Black pepper", amount: 0.5, unit: "tsp")
                ],
                instructions: [
                    "Whisk eggs with milk, salt, and pepper",
                    "Sauté spinach until wilted, set aside",
                    "Melt butter in a non-stick pan over medium heat",
                    "Pour in egg mixture",
                    "Cook until edges begin to set",
                    "Add spinach and crumbled feta to one half",
                    "Add halved cherry tomatoes",
                    "Fold omelette in half",
                    "Cook for 1-2 more minutes and serve"
                ],
                nutritionalInfo: NutritionalInfo(calories: 380, protein: 26, carbohydrates: 6, fat: 28, fiber: 2, sugar: 3, sodium: 820),
                tags: ["Breakfast", "Quick", "Keto"],
                dietaryPreferences: [.vegetarian, .glutenFree, .lowCarb, .keto, .highProtein]
            ),
            Recipe(
                name: "Coconut Curry Chicken",
                description: "Creamy Thai-inspired coconut curry with tender chicken and vegetables",
                cuisine: "Thai",
                preparationTime: 15,
                cookingTime: 30,
                difficulty: .medium,
                servings: 4,
                imageURL: "flame.circle.fill",
                ingredients: [
                    Ingredient(name: "Chicken breast", amount: 600, unit: "g"),
                    Ingredient(name: "Coconut milk", amount: 400, unit: "ml"),
                    Ingredient(name: "Red curry paste", amount: 3, unit: "tbsp"),
                    Ingredient(name: "Bell peppers", amount: 2, unit: "medium"),
                    Ingredient(name: "Bamboo shoots", amount: 200, unit: "g"),
                    Ingredient(name: "Fish sauce", amount: 2, unit: "tbsp"),
                    Ingredient(name: "Brown sugar", amount: 1, unit: "tbsp"),
                    Ingredient(name: "Thai basil", amount: 20, unit: "leaves")
                ],
                instructions: [
                    "Cut chicken into bite-sized pieces",
                    "Heat oil in a large pan or wok",
                    "Fry curry paste until fragrant",
                    "Add chicken and cook until no longer pink",
                    "Pour in coconut milk and bring to simmer",
                    "Add sliced bell peppers and bamboo shoots",
                    "Stir in fish sauce and brown sugar",
                    "Simmer for 15-20 minutes",
                    "Add Thai basil and serve over jasmine rice"
                ],
                nutritionalInfo: NutritionalInfo(calories: 420, protein: 38, carbohydrates: 16, fat: 24, fiber: 3, sugar: 8, sodium: 860),
                tags: ["Thai", "Curry", "Dinner"],
                dietaryPreferences: [.glutenFree, .highProtein]
            )
        ]
    }
    
    // MARK: - Restaurant Database
    
    private func loadRestaurantDatabase(near location: CLLocationCoordinate2D) -> [Restaurant] {
        let baseLatitude = location.latitude
        let baseLongitude = location.longitude
        
        return [
            Restaurant(
                name: "The Green Kitchen",
                description: "Farm-to-table restaurant specializing in organic, locally-sourced ingredients",
                cuisine: "Contemporary",
                address: "123 Main Street, San Francisco, CA",
                latitude: baseLatitude + 0.001,
                longitude: baseLongitude + 0.001,
                phone: "+1 (415) 555-0123",
                website: "https://greenkitchen-sf.com",
                rating: 4.7,
                priceLevel: .moderate,
                imageURL: "leaf.fill",
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
                    ),
                    MenuItem(
                        name: "Wild Salmon Plate",
                        description: "Grilled wild-caught salmon with quinoa and asparagus",
                        price: 24.99,
                        nutritionalInfo: NutritionalInfo(calories: 480, protein: 44, carbohydrates: 32, fat: 20, fiber: 6, sugar: 3, sodium: 380),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    )
                ],
                openingHours: ["Mon-Fri: 11:00 AM - 10:00 PM", "Sat-Sun: 10:00 AM - 11:00 PM"]
            ),
            Restaurant(
                name: "Spice Route",
                description: "Authentic Indian cuisine with a modern twist and traditional recipes",
                cuisine: "Indian",
                address: "456 Oak Avenue, San Francisco, CA",
                latitude: baseLatitude - 0.002,
                longitude: baseLongitude + 0.003,
                phone: "+1 (415) 555-0234",
                website: "https://spiceroute-sf.com",
                rating: 4.5,
                priceLevel: .moderate,
                imageURL: "flame.fill",
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
                    ),
                    MenuItem(
                        name: "Lamb Vindaloo",
                        description: "Spicy lamb curry with potatoes and aromatic spices",
                        price: 19.99,
                        nutritionalInfo: NutritionalInfo(calories: 520, protein: 38, carbohydrates: 24, fat: 32, fiber: 4, sugar: 8, sodium: 920),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    )
                ],
                openingHours: ["Daily: 12:00 PM - 10:00 PM"]
            ),
            Restaurant(
                name: "Mediterranean Breeze",
                description: "Fresh Mediterranean flavors in a cozy atmosphere with authentic recipes",
                cuisine: "Mediterranean",
                address: "789 Elm Street, San Francisco, CA",
                latitude: baseLatitude + 0.003,
                longitude: baseLongitude - 0.002,
                phone: "+1 (415) 555-0345",
                website: "https://medbreeze-sf.com",
                rating: 4.8,
                priceLevel: .expensive,
                imageURL: "fish.fill",
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
            ),
            Restaurant(
                name: "Sushi Zen",
                description: "Traditional Japanese sushi bar with fresh daily catches",
                cuisine: "Japanese",
                address: "234 Market Street, San Francisco, CA",
                latitude: baseLatitude + 0.0015,
                longitude: baseLongitude - 0.0025,
                phone: "+1 (415) 555-0456",
                website: "https://sushizen-sf.com",
                rating: 4.9,
                priceLevel: .expensive,
                imageURL: "sparkles",
                menuItems: [
                    MenuItem(
                        name: "Chef's Sashimi Platter",
                        description: "Selection of today's freshest fish",
                        price: 32.99,
                        nutritionalInfo: NutritionalInfo(calories: 320, protein: 52, carbohydrates: 2, fat: 12, fiber: 0, sugar: 0, sodium: 620),
                        dietaryPreferences: [.glutenFree, .highProtein, .lowCarb]
                    ),
                    MenuItem(
                        name: "Vegetable Tempura",
                        description: "Lightly battered seasonal vegetables",
                        price: 12.99,
                        nutritionalInfo: NutritionalInfo(calories: 380, protein: 8, carbohydrates: 45, fat: 18, fiber: 6, sugar: 4, sodium: 420),
                        dietaryPreferences: [.vegetarian]
                    ),
                    MenuItem(
                        name: "Teriyaki Salmon Bowl",
                        description: "Grilled salmon with teriyaki glaze over rice",
                        price: 18.99,
                        nutritionalInfo: NutritionalInfo(calories: 560, protein: 42, carbohydrates: 58, fat: 16, fiber: 2, sugar: 12, sodium: 880),
                        dietaryPreferences: [.highProtein]
                    )
                ],
                openingHours: ["Mon-Sat: 11:30 AM - 10:00 PM", "Sun: 5:00 PM - 9:00 PM"]
            ),
            Restaurant(
                name: "Bella Trattoria",
                description: "Family-owned Italian restaurant serving traditional pasta and pizza",
                cuisine: "Italian",
                address: "567 Columbus Ave, San Francisco, CA",
                latitude: baseLatitude - 0.0018,
                longitude: baseLongitude + 0.0022,
                phone: "+1 (415) 555-0567",
                website: "https://bellatrattoria-sf.com",
                rating: 4.6,
                priceLevel: .moderate,
                imageURL: "fork.knife",
                menuItems: [
                    MenuItem(
                        name: "Margherita Pizza",
                        description: "Classic pizza with fresh mozzarella and basil",
                        price: 16.99,
                        nutritionalInfo: NutritionalInfo(calories: 620, protein: 28, carbohydrates: 72, fat: 24, fiber: 4, sugar: 6, sodium: 940),
                        dietaryPreferences: [.vegetarian]
                    ),
                    MenuItem(
                        name: "Spaghetti Carbonara",
                        description: "Traditional Roman pasta with eggs and pancetta",
                        price: 18.99,
                        nutritionalInfo: NutritionalInfo(calories: 680, protein: 32, carbohydrates: 78, fat: 28, fiber: 3, sugar: 4, sodium: 820),
                        dietaryPreferences: [.highProtein]
                    ),
                    MenuItem(
                        name: "Eggplant Parmigiana",
                        description: "Breaded eggplant with marinara and mozzarella",
                        price: 15.99,
                        nutritionalInfo: NutritionalInfo(calories: 540, protein: 22, carbohydrates: 48, fat: 28, fiber: 8, sugar: 12, sodium: 760),
                        dietaryPreferences: [.vegetarian]
                    )
                ],
                openingHours: ["Daily: 11:00 AM - 11:00 PM"]
            ),
            Restaurant(
                name: "Taco Fiesta",
                description: "Vibrant Mexican cantina with authentic street tacos and margaritas",
                cuisine: "Mexican",
                address: "891 Mission Street, San Francisco, CA",
                latitude: baseLatitude + 0.0028,
                longitude: baseLongitude + 0.0015,
                phone: "+1 (415) 555-0678",
                website: "https://tacofiesta-sf.com",
                rating: 4.4,
                priceLevel: .budget,
                imageURL: "flame",
                menuItems: [
                    MenuItem(
                        name: "Carne Asada Tacos",
                        description: "Grilled steak tacos with cilantro and onions",
                        price: 12.99,
                        nutritionalInfo: NutritionalInfo(calories: 480, protein: 36, carbohydrates: 38, fat: 20, fiber: 6, sugar: 3, sodium: 720),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    ),
                    MenuItem(
                        name: "Veggie Burrito Bowl",
                        description: "Rice, beans, grilled vegetables, and guacamole",
                        price: 10.99,
                        nutritionalInfo: NutritionalInfo(calories: 520, protein: 16, carbohydrates: 72, fat: 18, fiber: 14, sugar: 8, sodium: 640),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    )
                ],
                openingHours: ["Sun-Thu: 11:00 AM - 10:00 PM", "Fri-Sat: 11:00 AM - 12:00 AM"]
            ),
            Restaurant(
                name: "Le Petit Bistro",
                description: "Charming French bistro offering classic dishes with wine pairings",
                cuisine: "French",
                address: "345 Bush Street, San Francisco, CA",
                latitude: baseLatitude - 0.0025,
                longitude: baseLongitude - 0.0018,
                phone: "+1 (415) 555-0789",
                website: "https://lepetitbistro-sf.com",
                rating: 4.7,
                priceLevel: .expensive,
                imageURL: "sparkle",
                menuItems: [
                    MenuItem(
                        name: "Coq au Vin",
                        description: "Braised chicken in red wine sauce",
                        price: 26.99,
                        nutritionalInfo: NutritionalInfo(calories: 580, protein: 48, carbohydrates: 22, fat: 32, fiber: 4, sugar: 8, sodium: 840),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    ),
                    MenuItem(
                        name: "Ratatouille",
                        description: "Provençal stewed vegetables",
                        price: 17.99,
                        nutritionalInfo: NutritionalInfo(calories: 280, protein: 8, carbohydrates: 38, fat: 12, fiber: 10, sugar: 16, sodium: 480),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    ),
                    MenuItem(
                        name: "Steak Frites",
                        description: "Grilled ribeye with crispy french fries",
                        price: 34.99,
                        nutritionalInfo: NutritionalInfo(calories: 820, protein: 56, carbohydrates: 48, fat: 44, fiber: 4, sugar: 2, sodium: 920),
                        dietaryPreferences: [.highProtein]
                    )
                ],
                openingHours: ["Tue-Sat: 5:30 PM - 10:30 PM", "Closed Sun-Mon"]
            ),
            Restaurant(
                name: "Pho Paradise",
                description: "Authentic Vietnamese cuisine specializing in traditional pho and banh mi",
                cuisine: "Vietnamese",
                address: "678 Larkin Street, San Francisco, CA",
                latitude: baseLatitude + 0.0032,
                longitude: baseLongitude - 0.0028,
                phone: "+1 (415) 555-0890",
                website: "https://phoparadise-sf.com",
                rating: 4.5,
                priceLevel: .budget,
                imageURL: "drop.fill",
                menuItems: [
                    MenuItem(
                        name: "Beef Pho",
                        description: "Traditional Vietnamese noodle soup with beef",
                        price: 11.99,
                        nutritionalInfo: NutritionalInfo(calories: 420, protein: 32, carbohydrates: 58, fat: 8, fiber: 4, sugar: 6, sodium: 1240),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    ),
                    MenuItem(
                        name: "Vegetarian Spring Rolls",
                        description: "Fresh vegetables wrapped in rice paper",
                        price: 8.99,
                        nutritionalInfo: NutritionalInfo(calories: 180, protein: 6, carbohydrates: 32, fat: 4, fiber: 4, sugar: 8, sodium: 340),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    ),
                    MenuItem(
                        name: "Grilled Lemongrass Chicken",
                        description: "Marinated chicken with vermicelli and vegetables",
                        price: 13.99,
                        nutritionalInfo: NutritionalInfo(calories: 480, protein: 38, carbohydrates: 54, fat: 12, fiber: 6, sugar: 10, sodium: 680),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    )
                ],
                openingHours: ["Daily: 10:00 AM - 9:00 PM"]
            ),
            Restaurant(
                name: "The Vegan Garden",
                description: "100% plant-based restaurant with creative and delicious vegan dishes",
                cuisine: "Vegan",
                address: "912 Valencia Street, San Francisco, CA",
                latitude: baseLatitude - 0.0012,
                longitude: baseLongitude + 0.0035,
                phone: "+1 (415) 555-0901",
                website: "https://vegangarden-sf.com",
                rating: 4.8,
                priceLevel: .moderate,
                imageURL: "leaf.circle.fill",
                menuItems: [
                    MenuItem(
                        name: "Impossible Burger",
                        description: "Plant-based burger with all the toppings",
                        price: 15.99,
                        nutritionalInfo: NutritionalInfo(calories: 520, protein: 28, carbohydrates: 48, fat: 22, fiber: 8, sugar: 10, sodium: 740),
                        dietaryPreferences: [.vegan, .vegetarian, .highProtein]
                    ),
                    MenuItem(
                        name: "Cauliflower Buffalo Wings",
                        description: "Crispy cauliflower in spicy buffalo sauce",
                        price: 12.99,
                        nutritionalInfo: NutritionalInfo(calories: 320, protein: 8, carbohydrates: 42, fat: 14, fiber: 6, sugar: 8, sodium: 680),
                        dietaryPreferences: [.vegan, .vegetarian]
                    ),
                    MenuItem(
                        name: "Jackfruit Tacos",
                        description: "Pulled jackfruit with fresh salsa and avocado",
                        price: 13.99,
                        nutritionalInfo: NutritionalInfo(calories: 380, protein: 10, carbohydrates: 58, fat: 14, fiber: 12, sugar: 18, sodium: 540),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    )
                ],
                openingHours: ["Mon-Sat: 11:00 AM - 9:00 PM", "Sun: 12:00 PM - 8:00 PM"]
            ),
            Restaurant(
                name: "Dragon Wok",
                description: "Contemporary Chinese restaurant with Szechuan and Cantonese specialties",
                cuisine: "Chinese",
                address: "456 Grant Avenue, San Francisco, CA",
                latitude: baseLatitude + 0.0019,
                longitude: baseLongitude + 0.0031,
                phone: "+1 (415) 555-1012",
                website: "https://dragonwok-sf.com",
                rating: 4.6,
                priceLevel: .moderate,
                imageURL: "wand.and.stars",
                menuItems: [
                    MenuItem(
                        name: "Kung Pao Chicken",
                        description: "Spicy stir-fried chicken with peanuts and vegetables",
                        price: 16.99,
                        nutritionalInfo: NutritionalInfo(calories: 540, protein: 38, carbohydrates: 42, fat: 24, fiber: 6, sugar: 12, sodium: 980),
                        dietaryPreferences: [.glutenFree, .highProtein]
                    ),
                    MenuItem(
                        name: "Mapo Tofu",
                        description: "Silky tofu in spicy Szechuan sauce",
                        price: 14.99,
                        nutritionalInfo: NutritionalInfo(calories: 380, protein: 18, carbohydrates: 28, fat: 22, fiber: 6, sugar: 8, sodium: 860),
                        dietaryPreferences: [.vegan, .vegetarian, .glutenFree]
                    ),
                    MenuItem(
                        name: "Beijing Duck",
                        description: "Crispy duck with pancakes and hoisin sauce",
                        price: 29.99,
                        nutritionalInfo: NutritionalInfo(calories: 680, protein: 42, carbohydrates: 48, fat: 34, fiber: 3, sugar: 14, sodium: 1020),
                        dietaryPreferences: [.highProtein]
                    )
                ],
                openingHours: ["Daily: 11:30 AM - 10:00 PM"]
            )
        ]
    }
}
