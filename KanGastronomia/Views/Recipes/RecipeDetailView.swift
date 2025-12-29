//
//  RecipeDetailView.swift
//  Gastronomia
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var selectedServings: Int
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _selectedServings = State(initialValue: recipe.servings)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image header
                    ZStack {
                        Rectangle()
                            .fill(Color.appCard)
                            .frame(height: 300)
                        
                        Image(systemName: "photo.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.appText.opacity(0.3))
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.appText)
                            
                            Text(recipe.description)
                                .font(.system(size: 16))
                                .foregroundColor(.appText.opacity(0.7))
                            
                            HStack(spacing: 20) {
                                InfoBadge(icon: "clock", text: "\(recipe.totalTime) min")
                                InfoBadge(icon: "chart.bar", text: recipe.difficulty.rawValue)
                                InfoBadge(icon: "person.2", text: "\(selectedServings) servings")
                            }
                        }
                        
                        // Dietary tags
                        if !recipe.dietaryPreferences.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(recipe.dietaryPreferences, id: \.self) { pref in
                                        DietaryTag(text: pref.rawValue)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .background(Color.appText.opacity(0.2))
                        
                        // Nutrition info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nutritional Information")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.appText)
                            
                            VStack(spacing: 8) {
                                NutritionRow(label: "Calories", value: "\(Int(recipe.nutritionalInfo.calories))", unit: "kcal")
                                NutritionRow(label: "Protein", value: String(format: "%.1f", recipe.nutritionalInfo.protein), unit: "g")
                                NutritionRow(label: "Carbs", value: String(format: "%.1f", recipe.nutritionalInfo.carbohydrates), unit: "g")
                                NutritionRow(label: "Fat", value: String(format: "%.1f", recipe.nutritionalInfo.fat), unit: "g")
                                NutritionRow(label: "Fiber", value: String(format: "%.1f", recipe.nutritionalInfo.fiber), unit: "g")
                            }
                            .padding()
                            .background(Color.appCard)
                            .cornerRadius(12)
                        }
                        
                        Divider()
                            .background(Color.appText.opacity(0.2))
                        
                        // Ingredients
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Ingredients")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                Spacer()
                                
                                Stepper(value: $selectedServings, in: 1...20) {
                                    EmptyView()
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(scaledIngredients) { ingredient in
                                    HStack {
                                        Circle()
                                            .fill(Color.appPrimary)
                                            .frame(width: 6, height: 6)
                                        
                                        Text(ingredientText(ingredient))
                                            .font(.system(size: 16))
                                            .foregroundColor(.appText)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.appCard)
                            .cornerRadius(12)
                        }
                        
                        Divider()
                            .background(Color.appText.opacity(0.2))
                        
                        // Instructions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.appText)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.appBackground)
                                            .frame(width: 28, height: 28)
                                            .background(Color.appPrimary)
                                            .clipShape(Circle())
                                        
                                        Text(instruction)
                                            .font(.system(size: 16))
                                            .foregroundColor(.appText)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.appCard)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var scaledIngredients: [Ingredient] {
        let scale = Double(selectedServings) / Double(recipe.servings)
        return recipe.ingredients.map { ingredient in
            Ingredient(
                id: ingredient.id,
                name: ingredient.name,
                amount: ingredient.amount * scale,
                unit: ingredient.unit
            )
        }
    }
    
    private func ingredientText(_ ingredient: Ingredient) -> String {
        let formattedAmount = String(format: "%.1f", ingredient.amount)
        return "\(formattedAmount) \(ingredient.unit) \(ingredient.name)"
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.appPrimary)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.appText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.appCard)
        .cornerRadius(8)
    }
}

struct DietaryTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.appBackground)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.appPrimary)
            .cornerRadius(16)
    }
}

struct NutritionRow: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.appText)
            
            Spacer()
            
            Text("\(value) \(unit)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appPrimary)
        }
    }
}

