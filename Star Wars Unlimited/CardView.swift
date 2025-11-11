//
//  CardView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var isChecked: Bool = false
    var quantity: Int = 0
    var style: CardStyle = .normal
    var onInfoTap: (() -> Void)?
    var onIncrement: (() -> Void)?
    var onDecrement: (() -> Void)?
    var onStyleTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image de la carte
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: card.frontArt ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(0.7, contentMode: .fit)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                }
                .frame(maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                // Bouton info en haut à gauche
                if let onInfoTap = onInfoTap {
                    Button(action: onInfoTap) {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.blue))
                            .shadow(radius: 2)
                    }
                    .padding(8)
                }
            }
            .overlay(alignment: .topTrailing) {
                // Style et checkmark en haut à droite
                if isChecked {
                    HStack(spacing: 4) {
                        if let onStyleTap = onStyleTap {
                            Button(action: onStyleTap) {
                                Text(style.icon)
                                    .font(.title3)
                                    .padding(6)
                                    .background(Circle().fill(Color.white.opacity(0.9)))
                                    .shadow(radius: 2)
                            }
                        }

                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                            .background(Circle().fill(Color.white))
                            .shadow(radius: 2)
                    }
                    .padding(8)
                }
            }
            .overlay(alignment: .bottom) {
                if isChecked, let onIncrement = onIncrement, let onDecrement = onDecrement {
                    HStack(spacing: 12) {
                        Button(action: onDecrement) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.red))
                                .shadow(radius: 3)
                        }

                        Text("\(quantity)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 30)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .shadow(radius: 3)

                        Button(action: onIncrement) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.green))
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Nom de la carte
                Text(card.displayName)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Type et aspects
                if !card.typeDisplay.isEmpty {
                    Text(card.typeDisplay)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if !card.aspectDisplay.isEmpty {
                    Text(card.aspectDisplay)
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                // Rareté
                HStack {
                    Text(rarityTranslation(for: card.rarity))
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(rarityBackgroundColor(for: card.rarity))
                        .foregroundColor(rarityTextColor(for: card.rarity))
                        .clipShape(Capsule())
                    
                    if card.unique {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    
                    Spacer()
                    
                    Text(card.cardNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func rarityBackgroundColor(for rarity: String) -> Color {
        switch rarity.lowercased() {
        case "common": return .gray.opacity(0.2)
        case "uncommon": return .green.opacity(0.2)
        case "rare": return .blue.opacity(0.2)
        case "legendary": return .orange.opacity(0.2)
        case "special": return .purple.opacity(0.2)
        default: return .gray.opacity(0.2)
        }
    }
    
    private func rarityTextColor(for rarity: String) -> Color {
        switch rarity.lowercased() {
        case "common": return .gray
        case "uncommon": return .green
        case "rare": return .blue
        case "legendary": return .orange
        case "special": return .purple
        default: return .primary
        }
    }

    private func rarityTranslation(for rarity: String) -> String {
        switch rarity.lowercased() {
        case "common": return "Commune"
        case "uncommon": return "Peu commune"
        case "rare": return "Rare"
        case "legendary": return "Légendaire"
        case "special": return "Spéciale"
        default: return rarity.capitalized
        }
    }
}

struct StatView: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    CardView(
        card: Card(
            set: "SOR",
            cardNumber: "016",
            name: "Luke Skywalker",
            subtitle: "Faithful Friend",
            type: "Unités",
            aspects: ["Heroism"],
            traits: ["Force", "Rebel"],
            arenas: ["Ground"],
            cost: "6",
            power: "4",
            hp: "7",
            frontText: "When Played: You may attack with a unit. It deals +2 damage for this attack.",
            backText: nil,
            epicAction: nil,
            doubleSided: false,
            backArt: nil,
            rarity: "Legendary",
            unique: true,
            keywords: [],
            artist: "Artist Name",
            frontArt: nil,
            marketPrice: "5.00"
        ),
        isChecked: true,
        quantity: 3,
        style: .hyperspace,
        onInfoTap: { print("Info tapped") },
        onIncrement: { print("Increment") },
        onDecrement: { print("Decrement") },
        onStyleTap: { print("Style tapped") }
    )
    .frame(width: 200)
}
