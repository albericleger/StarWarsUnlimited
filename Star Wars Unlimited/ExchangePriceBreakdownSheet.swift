//
//  ExchangePriceBreakdownSheet.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import SwiftUI

struct ExchangePriceBreakdownSheet<Manager: ExchangeManagerProtocol>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @ObservedObject var manager: Manager

    private var cardsBySet: [(set: String, cards: [Card])] {
        let checkedCards = api.cards.filter { manager.isChecked($0.id) }
        let grouped = Dictionary(grouping: checkedCards, by: { $0.set })
        return grouped.map { (set: $0.key, cards: $0.value.sorted { $0.cardNumber < $1.cardNumber }) }
            .sorted { $0.set < $1.set }
    }

    private var totalPrice: Double {
        manager.getTotalPrice(cards: api.cards)
    }

    var body: some View {
        NavigationStack {
            List {
                // Section information de mise à jour
                if let lastUpdate = api.lastUpdated {
                    Section {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dernière mise à jour des prix")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(formatDate(lastUpdate))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("Source: Market Prices")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                ForEach(cardsBySet, id: \.set) { setGroup in
                    Section(header: Text(setDisplayName(setGroup.set))) {
                        ForEach(setGroup.cards) { card in
                            ExchangeCardPriceRow(
                                card: card,
                                quantity: manager.getQuantity(card.id),
                                style: manager.getStyle(card.id)
                            )
                        }
                    }
                }

                // Section total
                Section {
                    HStack {
                        Text("Total")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f€", totalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Prix détaillés")
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

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func setDisplayName(_ setCode: String) -> String {
        switch setCode {
        case "SEC": return "Secret du Pouvoir"
        case "SOR": return "Étincelle de la Rébellion"
        case "SHD": return "Les Ombres de la Galaxie"
        case "TWI": return "Crépuscule de la République"
        case "JTL": return "Passage Vitesse Lumière"
        case "LOF": return "Légende de la force"
        case "IBH": return "Combat d'introduction: Hot"
        default: return setCode
        }
    }
}

struct ExchangeCardPriceRow: View {
    let card: Card
    let quantity: Int
    let style: CardStyle

    private var unitPrice: Double? {
        guard let priceString = card.marketPrice,
              let price = Double(priceString) else {
            return nil
        }
        return price * style.priceMultiplier
    }

    private var totalPrice: Double? {
        guard let price = unitPrice else { return nil }
        return price * Double(quantity)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(card.displayName)
                        .font(.body)
                        .fontWeight(.medium)

                    HStack(spacing: 4) {
                        Text(style.icon)
                            .font(.caption)
                        Text(style.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("×\(quantity)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    if let total = totalPrice {
                        Text(String(format: "%.2f€", total))
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    } else {
                        Text("N/A")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    if let unit = unitPrice {
                        Text(String(format: "%.2f€ / carte", unit))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        ExchangePriceBreakdownSheet(manager: ExchangeCardsManager())
            .environmentObject(StarWarsUnlimitedAPI())
    }
}
