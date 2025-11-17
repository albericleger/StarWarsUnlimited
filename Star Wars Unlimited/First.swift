//
//  First.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 18/10/2025.
//

import SwiftUI

struct First: View {
    var body: some View {
        ZStack {
            // Fond dégradé
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Titre principal
                VStack(spacing: 10) {
                    Text("STAR WARS")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(red: 0.9, green: 0.9, blue: 1.0)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: AppTheme.primaryBlue.opacity(0.5), radius: 10)

                    Text("UNLIMITED")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppTheme.accentOrange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: AppTheme.accentOrange.opacity(0.5), radius: 10)
                }
                .padding(.bottom, 20)

                // Boutons de navigation
                VStack(spacing: 16) {
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.title3)
                            Text("Parcourir les Cartes")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .fill(AppTheme.primaryGradient)
                                .shadow(color: AppTheme.primaryBlue.opacity(0.4), radius: 8, y: 4)
                        )
                    }

                    NavigationLink(destination: ClasseurView()) {
                        HStack {
                            Image(systemName: "book.fill")
                                .font(.title3)
                            Text("Parcourir les Classeurs")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .fill(AppTheme.primaryGradient)
                                .shadow(color: AppTheme.primaryBlue.opacity(0.4), radius: 8, y: 4)
                        )
                    }

                    NavigationLink(destination: EchangeView()) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title3)
                            Text("Échanges")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .fill(AppTheme.accentGradient)
                                .shadow(color: AppTheme.accentOrange.opacity(0.4), radius: 8, y: 4)
                        )
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        First()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
            .environmentObject(FilterManager())
    }
}
