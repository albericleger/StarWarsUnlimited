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
    @StateObject private var filterManager = FilterManager()
    @StateObject private var exchangeCardsManager = ExchangeCardsManager()
    @StateObject private var exchangePlayer2Manager = ExchangePlayer2Manager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                First()
            }
            .environmentObject(api)
            .environmentObject(checkedCardsManager)
            .environmentObject(filterManager)
            .environmentObject(exchangeCardsManager)
            .environmentObject(exchangePlayer2Manager)
            .task {
                // Pré-chargement des cartes au démarrage de l'application
                // Rafraîchir si vide ou si les prix sont obsolètes (> 6h)
                if api.cards.isEmpty || api.shouldUpdate() {
                    await api.fetchAllCards()
                }
            }
        }
    }
}
