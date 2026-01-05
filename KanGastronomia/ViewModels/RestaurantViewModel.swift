//
//  RestaurantViewModel.swift
//  Gastronomia
//

import Foundation
import CoreLocation
import Combine

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var selectedCuisine: String = ""
    @Published var selectedPriceLevel: PriceLevel?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService.shared
    
    init() {
        setupSearchObserver()
        loadRestaurants()
    }
    
    private func setupSearchObserver() {
        Publishers.CombineLatest3(
            $searchQuery,
            $selectedCuisine,
            $selectedPriceLevel
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] query, cuisine, priceLevel in
            self?.filterRestaurants(query: query, cuisine: cuisine, priceLevel: priceLevel)
        }
        .store(in: &cancellables)
    }
    
    func loadRestaurants() {
        // Use default location (San Francisco)
        let defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        fetchRestaurants(near: defaultLocation)
    }
    
    private func fetchRestaurants(near location: CLLocationCoordinate2D) {
        isLoading = true
        errorMessage = nil
        
        networkService.fetchRestaurants(near: location) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let restaurants):
                self.restaurants = restaurants
                self.filteredRestaurants = restaurants
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func filterRestaurants(query: String, cuisine: String, priceLevel: PriceLevel?) {
        var results = restaurants
        
        // Filter by search query
        if !query.isEmpty {
            results = results.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(query) ||
                restaurant.description.localizedCaseInsensitiveContains(query) ||
                restaurant.cuisine.localizedCaseInsensitiveContains(query)
            }
        }
        
        // Filter by cuisine
        if !cuisine.isEmpty {
            results = results.filter { $0.cuisine == cuisine }
        }
        
        // Filter by price level
        if let priceLevel = priceLevel {
            results = results.filter { $0.priceLevel == priceLevel }
        }
        
        filteredRestaurants = results
    }
    
    func clearFilters() {
        searchQuery = ""
        selectedCuisine = ""
        selectedPriceLevel = nil
    }
    
    var availableCuisines: [String] {
        Array(Set(restaurants.map { $0.cuisine })).sorted()
    }
    
    func getHealthyOptions(for restaurant: Restaurant, healthGoal: HealthGoal) -> [MenuItem] {
        switch healthGoal {
        case .weightLoss:
            return restaurant.menuItems.filter { ($0.nutritionalInfo?.calories ?? 1000) < 500 }
        case .muscleGain:
            return restaurant.menuItems.filter { ($0.nutritionalInfo?.protein ?? 0) > 30 }
        case .maintenance:
            return restaurant.menuItems
        case .healthyEating:
            return restaurant.menuItems.filter { !$0.dietaryPreferences.isEmpty }
        }
    }
    
    func distance(to restaurant: Restaurant, from userLocation: CLLocationCoordinate2D) -> Double {
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distanceInMeters = userCLLocation.distance(from: restaurantLocation)
        return distanceInMeters / 1609.34 // Convert to miles
    }
}

