//
//  ExchangeManagerProtocol.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import Foundation

protocol ExchangeManagerProtocol: ObservableObject {
    var cardEntries: [String: CardEntry] { get }
    var checkedCards: Set<String> { get }
    var totalCards: Int { get }

    func isChecked(_ cardId: String) -> Bool
    func getQuantity(_ cardId: String) -> Int
    func getStyle(_ cardId: String) -> CardStyle
    func getTotalPrice(cards: [Card]) -> Double
}

// Extension pour ExchangeCardsManager
extension ExchangeCardsManager: ExchangeManagerProtocol {}

// Extension pour ExchangePlayer2Manager
extension ExchangePlayer2Manager: ExchangeManagerProtocol {}
