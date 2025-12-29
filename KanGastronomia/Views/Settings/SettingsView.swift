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
                    }
                    .listRowBackground(Color.appCard)
                    
                    // App Information Section
                    Section(header: Text("About").foregroundColor(.appText)) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.appText.opacity(0.6))
                        }
                        
                        Button("Reset Onboarding") {
                            hasCompletedOnboarding = false
                        }
                    }
                    .listRowBackground(Color.appCard)
                    
                    // Data Section
                    Section(header: Text("Data").foregroundColor(.appText)) {
                        Button("Clear Cache") {
                            // Clear cache
                        }
                        
                        Button("Reset All Settings") {
                            resetSettings()
                        }
                        .foregroundColor(.red)
                    }
                    .listRowBackground(Color.appCard)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.appText)
                .accentColor(.appPrimary)
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

