//
//  SettingsView.swift
//  Gastronomia
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("selectedHealthGoal") private var selectedHealthGoal = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                Form {
                    // Health Goal Section
                    Section(header: Text("Health Goal").foregroundColor(.appText)) {
                        Picker("Current Goal", selection: $selectedHealthGoal) {
                            Text("None").tag("")
                            ForEach(HealthGoal.allCases, id: \.rawValue) { goal in
                                Text(goal.rawValue).tag(goal.rawValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.appText)
                    }
                    
                    // Notifications Section
                    Section(header: Text("Notifications").foregroundColor(.appText)) {
                        Toggle("Meal Reminders", isOn: .constant(false))
                            .tint(.appPrimary)
                            .foregroundColor(.appText)
                            .disabled(true)
                        
                        Toggle("Shopping List Updates", isOn: .constant(false))
                            .tint(.appPrimary)
                            .foregroundColor(.appText)
                            .disabled(true)
                    }
                    
                    // App Information Section
                    Section(header: Text("About").foregroundColor(.appText)) {
                        HStack {
                            Text("Version")
                                .foregroundColor(.appText)
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.appText.opacity(0.6))
                        }
                        
                        Button("Reset Onboarding") {
                            hasCompletedOnboarding = false
                        }
                        .foregroundColor(.appPrimary)
                        
                        Button("Privacy Policy") {
                            // Open privacy policy
                        }
                        .foregroundColor(.appPrimary)
                        
                        Button("Terms of Service") {
                            // Open terms
                        }
                        .foregroundColor(.appPrimary)
                    }
                    
                    // Data Section
                    Section(header: Text("Data").foregroundColor(.appText)) {
                        Button("Clear Cache") {
                            // Clear cache
                        }
                        .foregroundColor(.appPrimary)
                        
                        Button("Reset All Settings") {
                            resetSettings()
                        }
                        .foregroundColor(.red)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func resetSettings() {
        selectedHealthGoal = ""
    }
}

