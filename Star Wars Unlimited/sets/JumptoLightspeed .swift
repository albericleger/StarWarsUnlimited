//
//  Jump to Lightspeed .swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 10/11/2025.
//

import SwiftUI

struct JumptoLightspeed: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @EnvironmentObject private var checkedCardsManager: CheckedCardsManager
    @State private var selectedCard: Card?
    @State private var showingCardDetail = false

    private var checkedCards: [Card] {
        api.cards.filter { $0.set == "JTL" && checkedCardsManager.isChecked($0.id) }
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
                    Text("Cochez des cartes JTL pour les voir ici")
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
                                onInfoTap: {
                                    selectedCard = card
                                    showingCardDetail = true
                                },
                                onIncrement: {
                                    checkedCardsManager.incrementQuantity(card.id)
                                },
                                onDecrement: {
                                    checkedCardsManager.decrementQuantity(card.id)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Passage Vitesse Lumière")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingCardDetail) {
            if let card = selectedCard {
                CardDetailView(card: card)
            }
        }
    }
}

#Preview {
    NavigationStack {
        JumptoLightspeed()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
    }
}
