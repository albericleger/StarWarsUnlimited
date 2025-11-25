//
//  ClasseurView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 03/11/2025.
//

import SwiftUI

struct ClasseurView: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @EnvironmentObject private var checkedCardsManager: CheckedCardsManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // SOR - Mars 2024 (premier set)
                NavigationLink(destination: Hot()) {
                    Image("Hot")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)
                
                NavigationLink(destination: SecretView()) {
                    Image("secret")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)

                // SHD - Juillet 2024
                NavigationLink(destination: LegendsoftheForce ()) {
                    Image("légende de la force")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)

                // TWI - Novembre 2024
                NavigationLink(destination: JumptoLightspeed()) {
                    Image("passage vitesse lumière")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)

                // JTL - 2025
                NavigationLink(destination: TwilightoftheRepublic()) {
                    Image("l'ombre de la république")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)

                // LOF - 2025
                NavigationLink(destination: ShadowsoftheGalaxy()) {
                    Image("ombre de la galaxy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)

                // IBH - Battle Box
                NavigationLink(destination: sparkofrebelion()) {
                    Image("Spark of rebelion")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppTheme.cornerRadiusMedium)
                        .shadow(radius: AppTheme.shadowMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                                .stroke(AppTheme.primaryBlue.opacity(0.2), lineWidth: 2)
                        )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Mes Classeurs")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
}

#Preview {
    NavigationStack {
        ClasseurView()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
    }
}
