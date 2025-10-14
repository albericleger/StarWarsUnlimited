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
    private let sets = ["SOR", "SHD", "TWI", "JTL", "LOF", "IBH"]

    func fetchAllCards() async {
        isLoading = true
        errorMessage = nil

        do {
            var allCards: [Card] = []

            // Récupérer les cartes de chaque set
            for setCode in sets {
                let urlString = "\(baseURL)?q=set:\(setCode.lowercased())"
                guard let url = URL(string: urlString) else {
                    throw APIError.invalidURL
                }

                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }

                let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                allCards.append(contentsOf: cardResponse.data)

                print("Loaded \(setCode): \(cardResponse.data.count) cards (Total: \(allCards.count))")
            }

            self.cards = allCards.sorted { $0.name < $1.name }

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
            self.cards = cardResponse.data.sorted { $0.name < $1.name }

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
            self.cards = cardResponse.data.sorted { $0.name < $1.name }

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