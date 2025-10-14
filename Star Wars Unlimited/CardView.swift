//
//  CardView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image de la carte
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
                
                // Stats
                HStack {
                    if card.cost != nil {
                        StatView(label: "Coût", value: card.costDisplay, color: .orange)
                    }
                    if card.power != nil {
                        StatView(label: "Force", value: card.powerDisplay, color: .red)
                    }
                    if card.hp != nil {
                        StatView(label: "PV", value: card.hpDisplay, color: .green)
                    }
                }
                
                // Rareté
                HStack {
                    Text(card.rarity.capitalized)
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
    CardView(card: Card(
        set: "SOR",
        cardNumber: "016",
        name: "Luke Skywalker",
        subtitle: "Faithful Friend",
        type: "Unit",
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
    ))
    .frame(width: 200)
}