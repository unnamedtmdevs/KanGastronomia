//
//  RecipeListView.swift
//  Gastronomia
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showingFilters = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appText.opacity(0.5))
                        
                        TextField("Search recipes...", text: $viewModel.searchQuery)
                            .foregroundColor(.appText)
                            .accentColor(.appPrimary)
                    }
                    .padding(12)
                    .background(Color.appCard)
                    .cornerRadius(12)
                    
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20))
                            .foregroundColor(.appPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.appCard)
                            .cornerRadius(12)
                    }
                }
                .padding()
                
                // Active filters
                if !viewModel.selectedDietaryPreferences.isEmpty || !viewModel.selectedCuisine.isEmpty || viewModel.selectedDifficulty != nil {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.selectedDietaryPreferences, id: \.self) { pref in
                                FilterChip(title: pref.rawValue) {
                                    viewModel.selectedDietaryPreferences.removeAll { $0 == pref }
                                }
                            }
                            
                            if !viewModel.selectedCuisine.isEmpty {
                                FilterChip(title: viewModel.selectedCuisine) {
                                    viewModel.selectedCuisine = ""
                                }
                            }
                            
                            if let difficulty = viewModel.selectedDifficulty {
                                FilterChip(title: difficulty.rawValue) {
                                    viewModel.selectedDifficulty = nil
                                }
                            }
                            
                            Button(action: { viewModel.clearFilters() }) {
                                Text("Clear All")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.appPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)
                }
                
                // Recipe list
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .appPrimary))
                    Spacer()
                } else if viewModel.filteredRecipes.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.appText.opacity(0.3))
                        
                        Text("No recipes found")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.appText)
                        
                        Text("Try adjusting your filters")
                            .font(.system(size: 16))
                            .foregroundColor(.appText.opacity(0.6))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingFilters) {
            RecipeFiltersView(viewModel: viewModel)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                
                Image(systemName: "photo.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.appText.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.appText)
                    .lineLimit(2)
                
                Text(recipe.cuisine)
                    .font(.system(size: 14))
                    .foregroundColor(.appPrimary)
                
                HStack {
                    Label("\(recipe.totalTime) min", systemImage: "clock")
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.appText.opacity(0.5))
                    
                    Text(recipe.difficulty.rawValue)
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.appText.opacity(0.5))
                    
                    Text("\(Int(recipe.nutritionalInfo.calories)) cal")
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(16)
    }
}

struct FilterChip: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.appBackground)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.appBackground.opacity(0.7))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.appPrimary)
        .cornerRadius(20)
    }
}

struct RecipeFiltersView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Dietary Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Dietary Preferences")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appText)
                            
                            ForEach(DietaryPreference.allCases, id: \.self) { pref in
                                FilterOptionRow(
                                    title: pref.rawValue,
                                    isSelected: viewModel.selectedDietaryPreferences.contains(pref)
                                ) {
                                    if viewModel.selectedDietaryPreferences.contains(pref) {
                                        viewModel.selectedDietaryPreferences.removeAll { $0 == pref }
                                    } else {
                                        viewModel.selectedDietaryPreferences.append(pref)
                                    }
                                }
                            }
                        }
                        
                        // Cuisine
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cuisine")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appText)
                            
                            ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                FilterOptionRow(
                                    title: cuisine,
                                    isSelected: viewModel.selectedCuisine == cuisine
                                ) {
                                    viewModel.selectedCuisine = viewModel.selectedCuisine == cuisine ? "" : cuisine
                                }
                            }
                        }
                        
                        // Difficulty
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Difficulty")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appText)
                            
                            ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                                FilterOptionRow(
                                    title: difficulty.rawValue,
                                    isSelected: viewModel.selectedDifficulty == difficulty
                                ) {
                                    viewModel.selectedDifficulty = viewModel.selectedDifficulty == difficulty ? nil : difficulty
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(.appPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
        }
    }
}

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.appText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.appPrimary)
                }
            }
            .padding()
            .background(isSelected ? Color.appCard : Color.appBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appPrimary : Color.appText.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

