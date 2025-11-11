//
//  Star_Wars_UnlimitedApp.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import SwiftUI

@main
struct Star_Wars_UnlimitedApp: App {
    @StateObject private var api = StarWarsUnlimitedAPI()
    @StateObject private var checkedCardsManager = CheckedCardsManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                First()
            }
            .environmentObject(api)
            .environmentObject(checkedCardsManager)
            .task {
                // Pré-chargement des cartes au démarrage de l'application
                if api.cards.isEmpty {
                    await api.fetchAllCards()
                }
            }
        }
    }
}
