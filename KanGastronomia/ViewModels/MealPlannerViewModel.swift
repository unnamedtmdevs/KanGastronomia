//
//  MealPlannerViewModel.swift
//  Gastronomia
//

import Foundation
import Combine

class MealPlannerViewModel: ObservableObject {
    @Published var mealPlans: [MealPlan] = []
    @Published var currentPlan: MealPlan?
    @Published var shoppingList: [ShoppingItem] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMealPlans()
    }
    
    func createMealPlan(name: String, startDate: Date, endDate: Date) {
        let newPlan = MealPlan(name: name, startDate: startDate, endDate: endDate, meals: [])
        mealPlans.append(newPlan)
        currentPlan = newPlan
        saveMealPlans()
    }
    
    func addMealToPlan(recipe: Recipe, date: Date, mealType: MealType) {
        guard let plan = currentPlan else { return }
        
        let plannedMeal = PlannedMeal(date: date, mealType: mealType, recipe: recipe)
        var updatedMeals = plan.meals
        updatedMeals.append(plannedMeal)
        
        let updatedPlan = MealPlan(id: plan.id, name: plan.name, startDate: plan.startDate, endDate: plan.endDate, meals: updatedMeals)
        
        if let index = mealPlans.firstIndex(where: { $0.id == plan.id }) {
            mealPlans[index] = updatedPlan
        }
        
        currentPlan = updatedPlan
        updateShoppingList()
        saveMealPlans()
    }
    
    func removeMealFromPlan(_ meal: PlannedMeal) {
        guard let plan = currentPlan else { return }
        
        var updatedMeals = plan.meals
        updatedMeals.removeAll { $0.id == meal.id }
        
        let updatedPlan = MealPlan(id: plan.id, name: plan.name, startDate: plan.startDate, endDate: plan.endDate, meals: updatedMeals)
        
        if let index = mealPlans.firstIndex(where: { $0.id == plan.id }) {
            mealPlans[index] = updatedPlan
        }
        
        currentPlan = updatedPlan
        updateShoppingList()
        saveMealPlans()
    }
    
    func updateShoppingList() {
        guard let plan = currentPlan else {
            shoppingList = []
            return
        }
        
        shoppingList = plan.shoppingList
    }
    
    func toggleShoppingItem(_ item: ShoppingItem) {
        if let index = shoppingList.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = shoppingList[index]
            updatedItem.isPurchased.toggle()
            shoppingList[index] = updatedItem
        }
    }
    
    func getMealsForDate(_ date: Date) -> [PlannedMeal] {
        guard let plan = currentPlan else { return [] }
        
        let calendar = Calendar.current
        return plan.meals.filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.mealType.rawValue < $1.mealType.rawValue }
    }
    
    func getTotalNutritionForDate(_ date: Date) -> NutritionalInfo {
        let meals = getMealsForDate(date)
        
        var totalCalories = 0.0
        var totalProtein = 0.0
        var totalCarbs = 0.0
        var totalFat = 0.0
        var totalFiber = 0.0
        var totalSugar = 0.0
        var totalSodium = 0.0
        
        for meal in meals {
            let nutrition = meal.recipe.nutritionalInfo
            totalCalories += nutrition.calories
            totalProtein += nutrition.protein
            totalCarbs += nutrition.carbohydrates
            totalFat += nutrition.fat
            totalFiber += nutrition.fiber
            totalSugar += nutrition.sugar
            totalSodium += nutrition.sodium
        }
        
        return NutritionalInfo(
            calories: totalCalories,
            protein: totalProtein,
            carbohydrates: totalCarbs,
            fat: totalFat,
            fiber: totalFiber,
            sugar: totalSugar,
            sodium: totalSodium
        )
    }
    
    private func saveMealPlans() {
        if let encoded = try? JSONEncoder().encode(mealPlans) {
            UserDefaults.standard.set(encoded, forKey: "mealPlans")
        }
    }
    
    private func loadMealPlans() {
        if let data = UserDefaults.standard.data(forKey: "mealPlans"),
           let decoded = try? JSONDecoder().decode([MealPlan].self, from: data) {
            mealPlans = decoded
            currentPlan = decoded.first
            updateShoppingList()
        }
    }
}

