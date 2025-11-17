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
                // Ligne verticale centrale
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
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
                                        .fill(
                                            LinearGradient(
                                                colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )

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
                                .shadow(color: AppTheme.primaryBlue.opacity(0.5), radius: 8, y: 4)
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
                                        .fill(
                                            LinearGradient(
                                                colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )

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
                                .shadow(color: AppTheme.primaryGreen.opacity(0.5), radius: 8, y: 4)
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
                        VStack(spacing: 10) {
                            if difference > 0 {
                                Text(whoOwesWhom)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                Text(String(format: "%.2f€", difference))
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [AppTheme.accentOrange, .yellow],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: AppTheme.accentOrange.opacity(0.5), radius: 10)
                            } else {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.green)
                                    Text("Échange équilibré")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.black.opacity(0.7),
                                            Color.black.opacity(0.5)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.3),
                                                    Color.white.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
                        .padding(.bottom, 30)
                        .padding(.horizontal, 20)
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
                .cornerRadius(6)
                .clipped()
                .shadow(color: .black.opacity(0.3), radius: 4)
            }

            VStack(alignment: .leading, spacing: 3) {
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
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .fill(
                    LinearGradient(
                        colors: [
                            AppTheme.accentOrange,
                            AppTheme.accentOrange.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: AppTheme.accentOrange.opacity(0.3), radius: 5, y: 2)
    }
}

#Preview {
    EchangeView()
        .environmentObject(StarWarsUnlimitedAPI())
        .environmentObject(ExchangeCardsManager())
        .environmentObject(ExchangePlayer2Manager())
}
