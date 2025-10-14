//

//  CardDetailView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    @Environment(\.dismiss) private var dismiss
    @State private var isFlipped = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Image principale
                    AsyncImage(url: URL(string: isFlipped ? (card.backArt ?? card.frontArt ?? "") : (card.frontArt ?? ""))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(0.7, contentMode: .fit)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                            }
                    }
                    .frame(maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .onTapGesture {
                        if card.doubleSided {
                            withAnimation {
                                isFlipped.toggle()
                            }
                        }
                    }

                    // Bouton pour retourner la carte (si double face)
                    if card.type == "Leader" && card.doubleSided {
                        Button(action: {
                            withAnimation(.spring()) {
                                isFlipped.toggle()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.title2)
                                Text(isFlipped ? "Voir la forme Leader" : "Voir la forme Déployée")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        // Titre
                        Text(card.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Informations de base
                        CardInfoSection(title: "Informations") {
                            InfoRow(label: "Type", value: card.typeDisplay)
                            InfoRow(label: "Ensemble", value: card.set)
                            InfoRow(label: "Numéro", value: card.cardNumber)
                            InfoRow(label: "Rareté", value: card.rarity.capitalized)
                            
                            if !card.aspectDisplay.isEmpty {
                                InfoRow(label: "Aspects", value: card.aspectDisplay)
                            }
                            
                            if let traits = card.traits, !traits.isEmpty {
                                InfoRow(label: "Traits", value: traits.joined(separator: ", "))
                            }

                            if let arenas = card.arenas, !arenas.isEmpty {
                                InfoRow(label: "Arènes", value: arenas.joined(separator: ", "))
                            }

                            if let keywords = card.keywords, !keywords.isEmpty {
                                InfoRow(label: "Mots-clés", value: keywords.joined(separator: ", "))
                            }
                        }
                        
                        // Stats
                        if card.cost != nil || card.power != nil || card.hp != nil {
                            CardInfoSection(title: "Statistiques") {
                                if let cost = card.cost {
                                    InfoRow(label: "Coût", value: cost)
                                }
                                if let power = card.power {
                                    InfoRow(label: "Force", value: power)
                                }
                                if let hp = card.hp {
                                    InfoRow(label: "Points de vie", value: hp)
                                }
                            }
                        }
                        
                        // Epic Action
                        if let epicAction = card.epicAction, !epicAction.isEmpty {
                            CardInfoSection(title: "Action Épique") {
                                Text(epicAction)
                                    .font(.body)
                                    .foregroundColor(.orange)
                            }
                        }

                        // Textes
                        if isFlipped {
                            if let backText = card.backText, !backText.isEmpty {
                                CardInfoSection(title: "Effet (Verso)") {
                                    Text(backText)
                                        .font(.body)
                                }
                            }
                        } else {
                            if let frontText = card.frontText, !frontText.isEmpty {
                                CardInfoSection(title: "Effet") {
                                    Text(frontText)
                                        .font(.body)
                                }
                            }
                        }

                        // Artiste
                        if let artist = card.artist, !artist.isEmpty {
                            CardInfoSection(title: "Artiste") {
                                Text(artist)
                                    .font(.body)
                                    .italic()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Détails")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CardInfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            content
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
    }
}

#Preview {
    CardDetailView(card: Card(
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
}
