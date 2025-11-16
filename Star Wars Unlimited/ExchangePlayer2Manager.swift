//
//  ExchangePlayer2Manager.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import Foundation
import Combine

class ExchangePlayer2Manager: ObservableObject {
    @Published var cardEntries: [String: CardEntry] = [:]

    private let userDefaultsKey = "exchangePlayer2Entries"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        loadExchangeCards()
    }

    // Computed property pour compatibilité
    var checkedCards: Set<String> {
        Set(cardEntries.keys)
    }

    // Pour compatibilité
    var cardQuantities: [String: Int] {
        cardEntries.mapValues { $0.quantity }
    }

    // Charger les entrées depuis UserDefaults
    func loadExchangeCards() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            print("📁 Aucune carte joueur 2 sauvegardée")
            return
        }

        do {
            let entries = try decoder.decode([String: CardEntry].self, from: data)
            cardEntries = entries
            print("✅ Chargé \(cardEntries.count) cartes joueur 2 avec styles depuis JSON")
        } catch {
            print("❌ Erreur lors du chargement joueur 2: \(error.localizedDescription)")
        }
    }

    // Sauvegarder en JSON dans UserDefaults
    func saveExchangeCards() {
        do {
            let data = try encoder.encode(cardEntries)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            print("💾 Sauvegardé \(cardEntries.count) cartes joueur 2 avec styles en JSON")
        } catch {
            print("❌ Erreur lors de la sauvegarde joueur 2: \(error.localizedDescription)")
        }
    }

    // Toggle une carte (cocher/décocher)
    func toggleCard(_ cardId: String) {
        if cardEntries[cardId] != nil {
            cardEntries.removeValue(forKey: cardId)
        } else {
            cardEntries[cardId] = CardEntry(quantity: 1, style: .normal)
        }
        saveExchangeCards()
    }

    // Obtenir la quantité d'une carte
    func getQuantity(_ cardId: String) -> Int {
        return cardEntries[cardId]?.quantity ?? 0
    }

    // Obtenir le style d'une carte
    func getStyle(_ cardId: String) -> CardStyle {
        return cardEntries[cardId]?.style ?? .normal
    }

    // Définir le style d'une carte
    func setStyle(_ cardId: String, style: CardStyle) {
        if var entry = cardEntries[cardId] {
            entry.style = style
            cardEntries[cardId] = entry
            saveExchangeCards()
        }
    }

    // Définir la quantité d'une carte
    func setQuantity(_ cardId: String, quantity: Int) {
        if quantity <= 0 {
            cardEntries.removeValue(forKey: cardId)
        } else if var entry = cardEntries[cardId] {
            entry.quantity = quantity
            cardEntries[cardId] = entry
        } else {
            cardEntries[cardId] = CardEntry(quantity: quantity, style: .normal)
        }
        saveExchangeCards()
    }

    // Incrémenter la quantité
    func incrementQuantity(_ cardId: String) {
        if var entry = cardEntries[cardId] {
            entry.quantity += 1
            cardEntries[cardId] = entry
        } else {
            cardEntries[cardId] = CardEntry(quantity: 1, style: .normal)
        }
        saveExchangeCards()
    }

    // Décrémenter la quantité
    func decrementQuantity(_ cardId: String) {
        guard var entry = cardEntries[cardId], entry.quantity > 0 else { return }
        if entry.quantity == 1 {
            cardEntries.removeValue(forKey: cardId)
        } else {
            entry.quantity -= 1
            cardEntries[cardId] = entry
        }
        saveExchangeCards()
    }

    // Vérifier si une carte est cochée
    func isChecked(_ cardId: String) -> Bool {
        return cardEntries[cardId] != nil
    }

    // Tout décocher
    func clearAll() {
        cardEntries.removeAll()
        saveExchangeCards()
    }

    // Obtenir le nombre total de cartes
    var totalCards: Int {
        cardEntries.values.map(\.quantity).reduce(0, +)
    }

    // Calculer le prix total
    func getTotalPrice(cards: [Card]) -> Double {
        var total: Double = 0.0
        for (cardId, entry) in cardEntries {
            if let card = cards.first(where: { $0.id == cardId }),
               let priceString = card.marketPrice,
               let price = Double(priceString) {
                total += price * Double(entry.quantity)
            }
        }
        return total
    }

    // Obtenir le prix d'une carte spécifique
    func getCardPrice(card: Card) -> Double? {
        guard let priceString = card.marketPrice,
              let price = Double(priceString) else {
            return nil
        }
        let quantity = getQuantity(card.id)
        return price * Double(quantity)
    }

    // Exporter en JSON pour partage/backup
    func exportToJSON() -> String? {
        do {
            let data = try encoder.encode(cardEntries)
            return String(data: data, encoding: .utf8)
        } catch {
            print("❌ Erreur lors de l'export JSON joueur 2: \(error.localizedDescription)")
            return nil
        }
    }

    // Importer depuis JSON
    func importFromJSON(_ jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            print("❌ Impossible de convertir le JSON en data")
            return
        }

        do {
            let entries = try decoder.decode([String: CardEntry].self, from: data)
            cardEntries = entries
            saveExchangeCards()
            print("✅ Importé \(cardEntries.count) cartes joueur 2 depuis JSON")
        } catch {
            print("❌ Erreur lors de l'import JSON joueur 2: \(error.localizedDescription)")
        }
    }
}
