//
//  OnboardingView.swift
//  Gastronomia
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedHealthGoal") private var selectedHealthGoal = ""
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    WelcomePageView()
                        .tag(0)
                    
                    FeaturesPageView()
                        .tag(1)
                    
                    HealthGoalPageView(selectedGoal: $selectedHealthGoal)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentPage == index ? Color.appPrimary : Color.appText.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Action buttons
                    if currentPage < 2 {
                        PrimaryButton(title: "Continue") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        if currentPage > 0 {
                            Button("Skip") {
                                hasCompletedOnboarding = true
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.appText.opacity(0.7))
                        }
                    } else {
                        PrimaryButton(title: "Get Started") {
                            hasCompletedOnboarding = true
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.appPrimary)
            
            VStack(spacing: 12) {
                Text("Welcome to")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText.opacity(0.8))
                
                Text("Gastronomia")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.appPrimary)
            }
            
            Text("Your personal culinary assistant for a healthier, more delicious life")
                .font(.system(size: 18))
                .foregroundColor(.appText.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FeaturesPageView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("What You'll Love")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.appPrimary)
            
            VStack(spacing: 30) {
                FeatureRow(icon: "book.fill", title: "Curated Recipes", description: "Browse chef-approved recipes with detailed nutrition info")
                
                FeatureRow(icon: "calendar.badge.clock", title: "Meal Planning", description: "Create personalized meal plans based on your health goals")
                
                FeatureRow(icon: "map.fill", title: "Restaurant Finder", description: "Discover dining options that match your preferences")
                
                FeatureRow(icon: "cart.fill", title: "Shopping Lists", description: "Auto-generated shopping lists from your meal plans")
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.appPrimary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.appText)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.appText.opacity(0.7))
            }
        }
    }
}

struct HealthGoalPageView: View {
    @Binding var selectedGoal: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 12) {
                Text("Choose Your")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText.opacity(0.8))
                
                Text("Health Goal")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.appPrimary)
            }
            
            Text("We'll personalize your experience based on your goal")
                .font(.system(size: 16))
                .foregroundColor(.appText.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 16) {
                ForEach(HealthGoal.allCases, id: \.rawValue) { goal in
                    GoalButton(
                        title: goal.rawValue,
                        icon: iconForGoal(goal),
                        isSelected: selectedGoal == goal.rawValue
                    ) {
                        selectedGoal = goal.rawValue
                    }
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
    
    private func iconForGoal(_ goal: HealthGoal) -> String {
        switch goal {
        case .weightLoss:
            return "figure.run"
        case .muscleGain:
            return "figure.strengthtraining.traditional"
        case .maintenance:
            return "heart.fill"
        case .healthyEating:
            return "leaf.fill"
        }
    }
}

struct GoalButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .appBackground : .appPrimary)
                    .frame(width: 40)
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? .appBackground : .appText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.appBackground)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.appPrimary : Color.appCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appPrimary : Color.appText.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct PermissionFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.appPrimary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appText)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.appText.opacity(0.6))
            }
        }
    }
}

