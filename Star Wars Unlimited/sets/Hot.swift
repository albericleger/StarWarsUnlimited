//
//  Hot.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 10/11/2025.
//

import SwiftUI

struct Hot: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @EnvironmentObject private var checkedCardsManager: CheckedCardsManager
    @State private var selectedCard: Card?
    @State private var showingCardDetail = false
    @State private var showingStylePicker = false
    @State private var cardForStyleChange: Card?

    private var checkedCards: [Card] {
        api.cards.filter { $0.set == "IBH" && checkedCardsManager.isChecked($0.id) }
            .sorted { $0.cardNumber < $1.cardNumber }
    }

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            if checkedCards.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Aucune carte sélectionnée")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Cochez des cartes IBH pour les voir ici")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 400)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(checkedCards.count) carte\(checkedCards.count > 1 ? "s" : "")")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.top)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(checkedCards) { card in
                            CardView(
                                card: card,
                                isChecked: true,
                                quantity: checkedCardsManager.getQuantity(card.id),
                                style: checkedCardsManager.getStyle(card.id),
                                onInfoTap: {
                                    selectedCard = card
                                    showingCardDetail = true
                                },
                                onIncrement: {
                                    checkedCardsManager.incrementQuantity(card.id)
                                },
                                onDecrement: {
                                    checkedCardsManager.decrementQuantity(card.id)
                                },
                                onStyleTap: {
                                    cardForStyleChange = card
                                    showingStylePicker = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Combat d'introduction: Hot")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingCardDetail) {
            if let card = selectedCard {
                CardDetailView(card: card)
            }
        }
        .sheet(isPresented: $showingStylePicker) {
            if let card = cardForStyleChange {
                StylePickerSheet(
                    card: card,
                    currentStyle: checkedCardsManager.getStyle(card.id),
                    onStyleSelected: { newStyle in
                        checkedCardsManager.setStyle(card.id, style: newStyle)
                        showingStylePicker = false
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        Hot()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
    }
}

