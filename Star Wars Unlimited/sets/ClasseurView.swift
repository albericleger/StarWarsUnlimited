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
            VStack(spacing: 16) {
                
                // SOR - Mars 2024 (premier set)
                NavigationLink(destination: Hot()) {
                    Image("Hot")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: SecretView()) {
                    Image("secret")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                // SHD - Juillet 2024
                NavigationLink(destination: LegendsoftheForce ()) {
                    Image("légende de la force")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                // TWI - Novembre 2024
                NavigationLink(destination: JumptoLightspeed()) {
                    Image("passage vitesse lumière")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                // JTL - 2025
                NavigationLink(destination: TwilightoftheRepublic()) {
                    Image("l'ombre de la république")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                // LOF - 2025
                NavigationLink(destination: ShadowsoftheGalaxy()) {
                    Image("ombre de la galaxy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)

                // IBH - Battle Box
                NavigationLink(destination: sparkofrebelion()) {
                    Image("Spark of rebelion")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Mes Classeurs")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        ClasseurView()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
    }
}
