//
//  StarWarsUnlimitedAPI.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import Foundation
import Combine

@MainActor
class StarWarsUnlimitedAPI: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://api.swu-db.com/cards/search"
    private let sets = ["IBH", "LOF", "JTL", "TWI", "SHD", "SOR"]

    func fetchAllCards() async {
        isLoading = true
        errorMessage = nil

        do {
            // Récupérer toutes les cartes en parallèle avec TaskGroup
            let allCards = try await withThrowingTaskGroup(of: [Card].self) { group in
                // Lancer toutes les requêtes en parallèle
                for setCode in sets {
                    group.addTask {
                        let urlString = "\(self.baseURL)?q=set:\(setCode.lowercased())"
                        guard let url = URL(string: urlString) else {
                            throw APIError.invalidURL
                        }

                        let (data, response) = try await URLSession.shared.data(from: url)

                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 else {
                            throw APIError.invalidResponse
                        }

                        let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                        print("Loaded \(setCode): \(cardResponse.data.count) cards")
                        return cardResponse.data
                    }
                }

                // Collecter tous les résultats
                var cards: [Card] = []
                for try await setCards in group {
                    cards.append(contentsOf: setCards)
                }
                return cards
            }

            // Trier par set d'abord, puis par numéro de carte
            self.cards = allCards.sorted { card1, card2 in
                if card1.set != card2.set {
                    // Ordre des sets : du plus récent au plus ancien
                    let setOrder = ["IBH", "LOF", "JTL", "TWI", "SHD", "SOR"]
                    let index1 = setOrder.firstIndex(of: card1.set) ?? Int.max
                    let index2 = setOrder.firstIndex(of: card2.set) ?? Int.max
                    return index1 < index2
                }
                // Si même set, trier par numéro
                return card1.cardNumber < card2.cardNumber
            }
            print("Total cards loaded: \(allCards.count)")

        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching cards: \(error)")
        }

        isLoading = false
    }
    
    func searchCards(query: String) async {
        guard !query.isEmpty else {
            await fetchAllCards()
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            guard let url = URL(string: "\(baseURL)?q=\(encodedQuery)") else {
                throw APIError.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
            // Trier par set puis par numéro
            self.cards = cardResponse.data.sorted { card1, card2 in
                if card1.set != card2.set {
                    let setOrder = ["IBH", "LOF", "JTL", "TWI", "SHD", "SOR"]
                    let index1 = setOrder.firstIndex(of: card1.set) ?? Int.max
                    let index2 = setOrder.firstIndex(of: card2.set) ?? Int.max
                    return index1 < index2
                }
                return card1.cardNumber < card2.cardNumber
            }

        } catch {
            self.errorMessage = error.localizedDescription
            print("Error searching cards: \(error)")
        }

        isLoading = false
    }

    func filterCardsBySet(_ setCode: String) async {
        guard !setCode.isEmpty else {
            await fetchAllCards()
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            guard let url = URL(string: "\(baseURL)?q=set:\(setCode.lowercased())") else {
                throw APIError.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }

            let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
            // Trier par set puis par numéro
            self.cards = cardResponse.data.sorted { card1, card2 in
                if card1.set != card2.set {
                    let setOrder = ["IBH", "LOF", "JTL", "TWI", "SHD", "SOR"]
                    let index1 = setOrder.firstIndex(of: card1.set) ?? Int.max
                    let index2 = setOrder.firstIndex(of: card2.set) ?? Int.max
                    return index1 < index2
                }
                return card1.cardNumber < card2.cardNumber
            }

        } catch {
            self.errorMessage = error.localizedDescription
            print("Error filtering cards by set: \(error)")
        }

        isLoading = false
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse invalide du serveur"
        case .decodingError:
            return "Erreur lors du décodage des données"
        }
    }
}