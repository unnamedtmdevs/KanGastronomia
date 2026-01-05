//
//  HomeView.swift
//  Gastronomia
//

import SwiftUI

struct HomeView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @AppStorage("selectedHealthGoal") private var selectedHealthGoal = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Good Day!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.appText)
                            
                            if !selectedHealthGoal.isEmpty {
                                Text("Working towards: \(selectedHealthGoal)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.appText.opacity(0.7))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Featured Recipes
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Featured Recipes")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                Spacer()
                                
                                NavigationLink(destination: RecipeListView()) {
                                    Text("See All")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.appPrimary)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(recipeViewModel.getFeaturedRecipes()) { recipe in
                                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                            FeaturedRecipeCard(recipe: recipe)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Quick Meals
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Quick Meals")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(recipeViewModel.getQuickRecipes().prefix(5)) { recipe in
                                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                            QuickRecipeCard(recipe: recipe)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Healthy Options
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Healthy Options")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(recipeViewModel.getHealthyRecipes().prefix(3)) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        HealthyRecipeRow(recipe: recipe)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FeaturedRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(width: 280, height: 180)
                    .cornerRadius(16)
                
                if let imageURL = recipe.imageURL {
                    Image(systemName: imageURL)
                        .font(.system(size: 60))
                        .foregroundColor(.appPrimary)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.appText.opacity(0.3))
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appText)
                    .lineLimit(2)
                
                HStack {
                    Label("\(recipe.totalTime) min", systemImage: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.appText.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.appText.opacity(0.5))
                    
                    Text(recipe.difficulty.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.appPrimary)
                }
                
                Text("\(Int(recipe.nutritionalInfo.calories)) cal")
                    .font(.system(size: 13))
                    .foregroundColor(.appText.opacity(0.6))
            }
        }
        .frame(width: 280)
    }
}

struct QuickRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(width: 160, height: 120)
                    .cornerRadius(12)
                
                if let imageURL = recipe.imageURL {
                    Image(systemName: imageURL)
                        .font(.system(size: 40))
                        .foregroundColor(.appPrimary)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.appText.opacity(0.3))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.appText)
                    .lineLimit(2)
                
                Label("\(recipe.totalTime) min", systemImage: "clock")
                    .font(.system(size: 12))
                    .foregroundColor(.appPrimary)
            }
        }
        .frame(width: 160)
    }
}

struct HealthyRecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                
                if let imageURL = recipe.imageURL {
                    Image(systemName: imageURL)
                        .font(.system(size: 32))
                        .foregroundColor(.appPrimary)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.appText.opacity(0.3))
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appText)
                    .lineLimit(2)
                
                HStack {
                    Label("\(recipe.totalTime) min", systemImage: "clock")
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.appText.opacity(0.5))
                    
                    Text("\(Int(recipe.nutritionalInfo.calories)) cal")
                        .font(.system(size: 13))
                        .foregroundColor(.appPrimary)
                }
                
                if !recipe.dietaryPreferences.isEmpty {
                    Text(recipe.dietaryPreferences.first?.rawValue ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.appText.opacity(0.6))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.appText.opacity(0.3))
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(12)
    }
}

