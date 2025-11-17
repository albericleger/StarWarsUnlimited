//
//  EchangeView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import SwiftUI

struct EchangeView: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @EnvironmentObject private var player1Manager: ExchangeCardsManager
    @EnvironmentObject private var player2Manager: ExchangePlayer2Manager

    private var player1Total: Double {
        player1Manager.getTotalPrice(cards: api.cards)
    }

    private var player2Total: Double {
        player2Manager.getTotalPrice(cards: api.cards)
    }

    private var difference: Double {
        abs(player1Total - player2Total)
    }

    private var whoOwesWhom: String {
        if player1Total > player2Total {
            return "Joueur 2 doit ajouter"
        } else if player2Total > player1Total {
            return "Joueur 1 doit ajouter"
        } else {
            return "Échange équilibré"
        }
    }

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                // Ligne verticale centrale orange
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 3)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )

                HStack(spacing: 0) {
                    // Colonne Joueur 1
                    VStack(spacing: 12) {
                        // Bouton + Info Joueur 1
                        VStack(spacing: 8) {
                            NavigationLink(destination: EchangeView2()) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 60, height: 60)

                                    VStack(spacing: 2) {
                                        Image(systemName: "person.fill")
                                            .font(
                                                .system(size: 18, weight: .bold)
                                            )
                                            .foregroundColor(.white)
                                        Text("J1")
                                            .font(
                                                .system(size: 10, weight: .bold)
                                            )
                                            .foregroundColor(.white)
                                    }
                                }
                                .shadow(radius: 4)
                            }

                            if player1Manager.totalCards > 0 {
                                Text(
                                    "\(player1Manager.totalCards) carte\(player1Manager.totalCards > 1 ? "s" : "")"
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                                Text(String(format: "%.2f€", player1Total))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            } else {
                                Text("Aucune carte")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)

                        // Cartes Joueur 1
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(
                                    Array(player1Manager.cardEntries.keys),
                                    id: \.self
                                ) { cardId in
                                    if let card = api.cards.first(where: {
                                        $0.id == cardId
                                    }) {
                                        CompactCardRectangle(
                                            card: card,
                                            quantity:
                                                player1Manager.getQuantity(
                                                    cardId
                                                ),
                                            style: player1Manager.getStyle(cardId)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .frame(width: geometry.size.width / 2)

                    // Colonne Joueur 2
                    VStack(spacing: 12) {
                        // Bouton + Info Joueur 2
                        VStack(spacing: 8) {
                            NavigationLink(destination: EchangeView3()) {
                                ZStack {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 60, height: 60)

                                    VStack(spacing: 2) {
                                        Image(systemName: "person.fill")
                                            .font(
                                                .system(size: 18, weight: .bold)
                                            )
                                            .foregroundColor(.white)
                                        Text("J2")
                                            .font(
                                                .system(size: 10, weight: .bold)
                                            )
                                            .foregroundColor(.white)
                                    }
                                }
                                .shadow(radius: 4)
                            }

                            if player2Manager.totalCards > 0 {
                                Text(
                                    "\(player2Manager.totalCards) carte\(player2Manager.totalCards > 1 ? "s" : "")"
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                                Text(String(format: "%.2f€", player2Total))
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            } else {
                                Text("Aucune carte")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)

                        // Cartes Joueur 2
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(
                                    Array(player2Manager.cardEntries.keys),
                                    id: \.self
                                ) { cardId in
                                    if let card = api.cards.first(where: {
                                        $0.id == cardId
                                    }) {
                                        CompactCardRectangle(
                                            card: card,
                                            quantity:
                                                player2Manager.getQuantity(
                                                    cardId
                                                ),
                                            style: player2Manager.getStyle(cardId)
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .frame(width: geometry.size.width / 2)
                }

                // Affichage de la différence en bas
                if player1Manager.totalCards > 0 || player2Manager.totalCards > 0 {
                    VStack {
                        Spacer()
                        VStack(spacing: 8) {
                            if difference > 0 {
                                Text(whoOwesWhom)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.2f€", difference))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Échange équilibré")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.95))
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct CompactCardRectangle: View {
    let card: Card
    let quantity: Int
    let style: CardStyle

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.orange)
            .frame(height: 80)
            .overlay(
                HStack(spacing: 8) {
                    // Image de la carte
                    if let frontArt = card.frontArt, let imageURL = URL(string: frontArt) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 50, height: 70)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "photo")
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(width: 50, height: 70)
                            @unknown default:
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 50, height: 70)
                        .cornerRadius(4)
                        .clipped()
                        .padding(.leading, 4)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        if let subtitle = card.subtitle {
                            Text(subtitle)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                        }

                        HStack(spacing: 4) {
                            Text(style.icon)
                                .font(.caption2)
                            Text("×\(quantity)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()

                    if let priceString = card.marketPrice,
                        let price = Double(priceString)
                    {
                        let adjustedPrice = price * style.priceMultiplier
                        Text(String(format: "%.2f€", adjustedPrice * Double(quantity)))
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 6)
                    }
                }
            )
    }
}

#Preview {
    EchangeView()
        .environmentObject(StarWarsUnlimitedAPI())
        .environmentObject(ExchangeCardsManager())
        .environmentObject(ExchangePlayer2Manager())
}
