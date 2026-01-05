//
//  RestaurantFinderView.swift
//  Gastronomia
//

import SwiftUI
import MapKit

struct RestaurantFinderView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var showingFilters = false
    @AppStorage("selectedHealthGoal") private var selectedHealthGoal = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.appText.opacity(0.5))
                            
                            TextField("Search restaurants...", text: $viewModel.searchQuery)
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
                    
                    // Restaurant list
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .appPrimary))
                        Spacer()
                    } else if viewModel.filteredRestaurants.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "map")
                                .font(.system(size: 60))
                                .foregroundColor(.appText.opacity(0.3))
                            
                            Text("No restaurants found")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appText)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredRestaurants) { restaurant in
                                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant, viewModel: viewModel)) {
                                        RestaurantCard(restaurant: restaurant, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Restaurants")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFilters) {
                RestaurantFiltersView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadRestaurants()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RestaurantCard: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.appCard)
                    .frame(height: 160)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                
                if let imageURL = restaurant.imageURL {
                    Image(systemName: imageURL)
                        .font(.system(size: 60))
                        .foregroundColor(.appPrimary)
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.appText.opacity(0.3))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(restaurant.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.appText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.appPrimary)
                        
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.appText)
                    }
                }
                
                Text(restaurant.cuisine)
                    .font(.system(size: 14))
                    .foregroundColor(.appPrimary)
                
                HStack {
                    Text(restaurant.priceLevel.rawValue)
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.appText.opacity(0.5))
                    
                    Text(restaurant.address.components(separatedBy: ",").last?.trimmingCharacters(in: .whitespaces) ?? "Nearby")
                        .font(.system(size: 13))
                        .foregroundColor(.appText.opacity(0.7))
                }
                
                Text(restaurant.address)
                    .font(.system(size: 13))
                    .foregroundColor(.appText.opacity(0.6))
                    .lineLimit(1)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.appCard)
        .cornerRadius(16)
    }
}

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    @AppStorage("selectedHealthGoal") private var selectedHealthGoal = ""
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image header
                    ZStack {
                        Rectangle()
                            .fill(Color.appCard)
                            .frame(height: 250)
                        
                        if let imageURL = restaurant.imageURL {
                            Image(systemName: imageURL)
                                .font(.system(size: 100))
                                .foregroundColor(.appPrimary)
                        } else {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.appText.opacity(0.3))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Restaurant info
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(restaurant.name)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.appPrimary)
                                    
                                    Text(String(format: "%.1f", restaurant.rating))
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.appText)
                                }
                            }
                            
                            Text(restaurant.cuisine + " • " + restaurant.priceLevel.rawValue)
                                .font(.system(size: 16))
                                .foregroundColor(.appPrimary)
                            
                            Text(restaurant.description)
                                .font(.system(size: 15))
                                .foregroundColor(.appText.opacity(0.7))
                        }
                        
                        Divider()
                            .background(Color.appText.opacity(0.2))
                        
                        // Contact info
                        VStack(alignment: .leading, spacing: 12) {
                            if let phone = restaurant.phone {
                                HStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.appPrimary)
                                        .frame(width: 24)
                                    
                                    Text(phone)
                                        .font(.system(size: 15))
                                        .foregroundColor(.appText)
                                }
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.appPrimary)
                                    .frame(width: 24)
                                
                                Text(restaurant.address)
                                    .font(.system(size: 15))
                                    .foregroundColor(.appText)
                            }
                        }
                        
                        // Opening hours
                        if !restaurant.openingHours.isEmpty {
                            Divider()
                                .background(Color.appText.opacity(0.2))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Opening Hours")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.appText)
                                
                                ForEach(restaurant.openingHours, id: \.self) { hours in
                                    Text(hours)
                                        .font(.system(size: 14))
                                        .foregroundColor(.appText.opacity(0.7))
                                }
                            }
                        }
                        
                        // Menu
                        if !restaurant.menuItems.isEmpty {
                            Divider()
                                .background(Color.appText.opacity(0.2))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Menu")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.appText)
                                
                                // Show healthy options if health goal is set
                                if !selectedHealthGoal.isEmpty, let goal = HealthGoal(rawValue: selectedHealthGoal) {
                                    let healthyItems = viewModel.getHealthyOptions(for: restaurant, healthGoal: goal)
                                    if !healthyItems.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Recommended for \(selectedHealthGoal)")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.appPrimary)
                                            
                                            ForEach(healthyItems) { item in
                                                MenuItemCard(item: item, isRecommended: true)
                                            }
                                        }
                                        
                                        if healthyItems.count < restaurant.menuItems.count {
                                            Text("Other Items")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.appText)
                                                .padding(.top, 8)
                                        }
                                    }
                                }
                                
                                // Show all menu items
                                ForEach(restaurant.menuItems) { item in
                                    MenuItemCard(item: item, isRecommended: false)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MenuItemCard: View {
    let item: MenuItem
    let isRecommended: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.appText)
                        
                        if isRecommended {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.appPrimary)
                        }
                    }
                    
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(.appText.opacity(0.7))
                        .lineLimit(2)
                    
                    if !item.dietaryPreferences.isEmpty {
                        Text(item.dietaryPreferences.map { $0.rawValue }.joined(separator: ", "))
                            .font(.system(size: 12))
                            .foregroundColor(.appPrimary)
                    }
                    
                    if let nutrition = item.nutritionalInfo {
                        Text("\(Int(nutrition.calories)) cal")
                            .font(.system(size: 13))
                            .foregroundColor(.appText.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appPrimary)
            }
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecommended ? Color.appPrimary : Color.clear, lineWidth: 2)
        )
    }
}

struct RestaurantFiltersView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
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
                        
                        // Price Level
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Price Range")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appText)
                            
                            ForEach(PriceLevel.allCases, id: \.self) { priceLevel in
                                FilterOptionRow(
                                    title: priceLevel.rawValue,
                                    isSelected: viewModel.selectedPriceLevel == priceLevel
                                ) {
                                    viewModel.selectedPriceLevel = viewModel.selectedPriceLevel == priceLevel ? nil : priceLevel
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

