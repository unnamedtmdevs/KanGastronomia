//
//  MealPlannerView.swift
//  Gastronomia
//

import SwiftUI

struct MealPlannerView: View {
    @StateObject private var viewModel = MealPlannerViewModel()
    @StateObject private var recipeViewModel = RecipeViewModel()
    @State private var showingRecipeSelector = false
    @State private var selectedDate: Date = Date()
    @State private var selectedMealType: MealType = .breakfast
    @State private var showingNewPlanSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.currentPlan == nil {
                    // Empty state
                    VStack(spacing: 24) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 70))
                            .foregroundColor(.appPrimary)
                        
                        Text("No Meal Plan Yet")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.appText)
                        
                        Text("Create your first meal plan to get started with organized eating")
                            .font(.system(size: 16))
                            .foregroundColor(.appText.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        PrimaryButton(title: "Create Meal Plan") {
                            showingNewPlanSheet = true
                        }
                        .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Calendar section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text(dateHeaderText)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.appText)
                                    
                                    Spacer()
                                    
                                    Button(action: { selectedDate = Date() }) {
                                        Text("Today")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.appPrimary)
                                    }
                                }
                                
                                // Simple date selector
                                HStack(spacing: 12) {
                                    Button(action: { changeDate(by: -1) }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.appPrimary)
                                            .frame(width: 40, height: 40)
                                            .background(Color.appCard)
                                            .cornerRadius(8)
                                    }
                                    
                                    Text(selectedDate, style: .date)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.appText)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background(Color.appCard)
                                        .cornerRadius(8)
                                    
                                    Button(action: { changeDate(by: 1) }) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.appPrimary)
                                            .frame(width: 40, height: 40)
                                            .background(Color.appCard)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                            
                            // Nutrition summary for the day
                            let dayNutrition = viewModel.getTotalNutritionForDate(selectedDate)
                            if dayNutrition.calories > 0 {
                                NutritionSummaryCard(nutrition: dayNutrition)
                                    .padding(.horizontal)
                            }
                            
                            // Meals for selected date
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(MealType.allCases, id: \.self) { mealType in
                                    MealTypeSection(
                                        mealType: mealType,
                                        date: selectedDate,
                                        meals: viewModel.getMealsForDate(selectedDate).filter { $0.mealType == mealType },
                                        onAddMeal: {
                                            selectedMealType = mealType
                                            showingRecipeSelector = true
                                        },
                                        onRemoveMeal: { meal in
                                            viewModel.removeMealFromPlan(meal)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            
                            // Shopping list
                            ShoppingListSection(items: $viewModel.shoppingList, viewModel: viewModel)
                                .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Meal Planner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.currentPlan != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingNewPlanSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingNewPlanSheet) {
                NewMealPlanView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingRecipeSelector) {
                RecipeSelectorView(
                    recipeViewModel: recipeViewModel,
                    onSelect: { recipe in
                        viewModel.addMealToPlan(recipe: recipe, date: selectedDate, mealType: selectedMealType)
                        showingRecipeSelector = false
                    }
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var dateHeaderText: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Today's Meals"
        } else if calendar.isDateInTomorrow(selectedDate) {
            return "Tomorrow's Meals"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return "\(formatter.string(from: selectedDate))'s Meals"
        }
    }
    
    private func changeDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

struct NutritionSummaryCard: View {
    let nutrition: NutritionalInfo
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Daily Nutrition")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.appText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                NutritionStat(label: "Calories", value: "\(Int(nutrition.calories))", unit: "kcal", color: .orange)
                NutritionStat(label: "Protein", value: String(format: "%.0f", nutrition.protein), unit: "g", color: .red)
                NutritionStat(label: "Carbs", value: String(format: "%.0f", nutrition.carbohydrates), unit: "g", color: .blue)
                NutritionStat(label: "Fat", value: String(format: "%.0f", nutrition.fat), unit: "g", color: .green)
            }
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(16)
    }
}

struct NutritionStat: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            
            Text(unit)
                .font(.system(size: 11))
                .foregroundColor(.appText.opacity(0.6))
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.appText.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct MealTypeSection: View {
    let mealType: MealType
    let date: Date
    let meals: [PlannedMeal]
    let onAddMeal: () -> Void
    let onRemoveMeal: (PlannedMeal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForMealType)
                    .foregroundColor(.appPrimary)
                
                Text(mealType.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appText)
                
                Spacer()
                
                Button(action: onAddMeal) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.appPrimary)
                        .font(.system(size: 22))
                }
            }
            
            if meals.isEmpty {
                Text("No meal planned")
                    .font(.system(size: 14))
                    .foregroundColor(.appText.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.appCard.opacity(0.5))
                    .cornerRadius(12)
            } else {
                ForEach(meals) { meal in
                    PlannedMealCard(meal: meal, onRemove: { onRemoveMeal(meal) })
                }
            }
        }
    }
    
    private var iconForMealType: String {
        switch mealType {
        case .breakfast:
            return "sunrise.fill"
        case .lunch:
            return "sun.max.fill"
        case .dinner:
            return "moon.stars.fill"
        case .snack:
            return "apple.logo"
        }
    }
}

struct PlannedMealCard: View {
    let meal: PlannedMeal
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                Image(systemName: "photo.fill")
                    .foregroundColor(.appText.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.recipe.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.appText)
                    .lineLimit(1)
                
                Text("\(Int(meal.recipe.nutritionalInfo.calories)) cal • \(meal.recipe.totalTime) min")
                    .font(.system(size: 13))
                    .foregroundColor(.appText.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(12)
    }
}

struct ShoppingListSection: View {
    @Binding var items: [ShoppingItem]
    let viewModel: MealPlannerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.appPrimary)
                
                Text("Shopping List")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.appText)
                
                Spacer()
                
                Text("\(items.filter { !$0.isPurchased }.count) items")
                    .font(.system(size: 14))
                    .foregroundColor(.appText.opacity(0.6))
            }
            
            if items.isEmpty {
                Text("Add meals to generate shopping list")
                    .font(.system(size: 14))
                    .foregroundColor(.appText.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.appCard.opacity(0.5))
                    .cornerRadius(12)
            } else {
                VStack(spacing: 8) {
                    ForEach(items) { item in
                        ShoppingItemRow(item: item, onToggle: {
                            viewModel.toggleShoppingItem(item)
                        })
                    }
                }
                .padding()
                .background(Color.appCard)
                .cornerRadius(12)
            }
        }
    }
}

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isPurchased ? .appPrimary : .appText.opacity(0.3))
                
                Text(item.name)
                    .font(.system(size: 15))
                    .foregroundColor(item.isPurchased ? .appText.opacity(0.5) : .appText)
                    .strikethrough(item.isPurchased)
                
                Spacer()
                
                Text("\(String(format: "%.1f", item.amount)) \(item.unit)")
                    .font(.system(size: 13))
                    .foregroundColor(.appText.opacity(0.6))
            }
        }
    }
}

struct NewMealPlanView: View {
    @ObservedObject var viewModel: MealPlannerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var planName = ""
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                Form {
                    Section(header: Text("Plan Details").foregroundColor(.appText)) {
                        TextField("Plan Name", text: $planName)
                            .foregroundColor(.appText)
                        
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .foregroundColor(.appText)
                        
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .foregroundColor(.appText)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Meal Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        viewModel.createMealPlan(name: planName.isEmpty ? "My Meal Plan" : planName, startDate: startDate, endDate: endDate)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
        }
    }
}

struct RecipeSelectorView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    let onSelect: (Recipe) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(recipeViewModel.recipes) { recipe in
                            Button(action: { onSelect(recipe) }) {
                                RecipeCard(recipe: recipe)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
        }
    }
}

