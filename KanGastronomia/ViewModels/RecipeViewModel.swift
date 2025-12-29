//
//  RecipeViewModel.swift
//  Gastronomia
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var selectedDietaryPreferences: [DietaryPreference] = []
    @Published var selectedCuisine: String = ""
    @Published var selectedDifficulty: DifficultyLevel?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService.shared
    
    init() {
        setupSearchObserver()
        loadRecipes()
    }
    
    private func setupSearchObserver() {
        Publishers.CombineLatest4(
            $searchQuery,
            $selectedDietaryPreferences,
            $selectedCuisine,
            $selectedDifficulty
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] query, preferences, cuisine, difficulty in
            self?.filterRecipes(query: query, preferences: preferences, cuisine: cuisine, difficulty: difficulty)
        }
        .store(in: &cancellables)
    }
    
    func loadRecipes() {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchRecipes { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                self.filteredRecipes = recipes
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func filterRecipes(query: String, preferences: [DietaryPreference], cuisine: String, difficulty: DifficultyLevel?) {
        var results = recipes
        
        // Filter by search query
        if !query.isEmpty {
            results = results.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(query) ||
                recipe.description.localizedCaseInsensitiveContains(query) ||
                recipe.cuisine.localizedCaseInsensitiveContains(query)
            }
        }
        
        // Filter by dietary preferences
        if !preferences.isEmpty {
            results = results.filter { recipe in
                !Set(recipe.dietaryPreferences).isDisjoint(with: Set(preferences))
            }
        }
        
        // Filter by cuisine
        if !cuisine.isEmpty {
            results = results.filter { $0.cuisine == cuisine }
        }
        
        // Filter by difficulty
        if let difficulty = difficulty {
            results = results.filter { $0.difficulty == difficulty }
        }
        
        filteredRecipes = results
    }
    
    func clearFilters() {
        searchQuery = ""
        selectedDietaryPreferences = []
        selectedCuisine = ""
        selectedDifficulty = nil
    }
    
    var availableCuisines: [String] {
        Array(Set(recipes.map { $0.cuisine })).sorted()
    }
    
    func getFeaturedRecipes(count: Int = 5) -> [Recipe] {
        Array(recipes.shuffled().prefix(count))
    }
    
    func getQuickRecipes() -> [Recipe] {
        recipes.filter { $0.totalTime <= 30 }.sorted { $0.totalTime < $1.totalTime }
    }
    
    func getHealthyRecipes() -> [Recipe] {
        recipes.filter { $0.nutritionalInfo.calories < 500 }
    }
}

