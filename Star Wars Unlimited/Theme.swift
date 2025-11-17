//
//  Theme.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 17/11/2025.
//

import SwiftUI

struct AppTheme {
    // Couleurs principales
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let primaryGreen = Color(red: 0.2, green: 0.7, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.15)
    static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.2)

    // Dégradés
    static let primaryGradient = LinearGradient(
        colors: [primaryBlue, primaryBlue.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [accentOrange, Color.red.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [cardBackground, cardBackground.opacity(0.8)],
        startPoint: .top,
        endPoint: .bottom
    )

    // Coins arrondis
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20

    // Ombres
    static let shadowLight: CGFloat = 2
    static let shadowMedium: CGFloat = 5
    static let shadowHeavy: CGFloat = 10
}

// Extension pour les boutons stylisés
extension View {
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(AppTheme.primaryGradient)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .shadow(radius: AppTheme.shadowMedium)
    }

    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(AppTheme.accentGradient)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .shadow(radius: AppTheme.shadowMedium)
    }

    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
            .shadow(radius: AppTheme.shadowLight)
    }
}
