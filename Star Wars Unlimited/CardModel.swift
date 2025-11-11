//
//  CardModel.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import Foundation

// MARK: - Card Response Models
struct CardResponse: Codable {
    let data: [Card]
    let totalCards: Int

    enum CodingKeys: String, CodingKey {
        case data
        case totalCards = "total_cards"
    }
}

struct Card: Codable, Identifiable {
    let set: String
    let cardNumber: String
    let name: String
    let subtitle: String?
    let type: String
    let aspects: [String]?
    let traits: [String]?
    let arenas: [String]?
    let cost: String?
    let power: String?
    let hp: String?
    let frontText: String?
    let backText: String?
    let epicAction: String?
    let doubleSided: Bool
    let backArt: String?
    let rarity: String
    let unique: Bool
    let keywords: [String]?
    let artist: String?
    let frontArt: String?
    let marketPrice: String?

    var id: String { "\(set)-\(cardNumber)" }

    enum CodingKeys: String, CodingKey {
        case set = "Set"
        case cardNumber = "Number"
        case name = "Name"
        case subtitle = "Subtitle"
        case type = "Type"
        case aspects = "Aspects"
        case traits = "Traits"
        case arenas = "Arenas"
        case cost = "Cost"
        case power = "Power"
        case hp = "HP"
        case frontText = "FrontText"
        case backText = "BackText"
        case epicAction = "EpicAction"
        case doubleSided = "DoubleSided"
        case backArt = "BackArt"
        case rarity = "Rarity"
        case unique = "Unique"
        case keywords = "Keywords"
        case artist = "Artist"
        case frontArt = "FrontArt"
        case marketPrice = "MarketPrice"
    }
}

// MARK: - Extensions for UI
extension Card {
    var displayName: String {
        if let subtitle = subtitle, !subtitle.isEmpty {
            return "\(name) - \(subtitle)"
        }
        return name
    }

    // URL de l'image à utiliser (français par défaut)
    var displayFrontArt: String? {
        // Construire l'URL de l'image française depuis le CDN officiel
        return "https://cdn.starwarsunlimited.com/\(set)/\(cardNumber)_FR.png"
    }

    var displayBackArt: String? {
        guard doubleSided else { return nil }
        return "https://cdn.starwarsunlimited.com/\(set)/\(cardNumber)_FR_BACK.png"
    }

    // Fallback sur l'image anglaise si la française ne charge pas
    var fallbackFrontArt: String? {
        frontArt
    }

    var fallbackBackArt: String? {
        backArt
    }
    
    var costDisplay: String {
        cost ?? "—"
    }

    var powerDisplay: String {
        power ?? "—"
    }

    var hpDisplay: String {
        hp ?? "—"
    }
    
    var rarityColor: String {
        switch rarity.lowercased() {
        case "common": return "gray"
        case "uncommon": return "green"
        case "rare": return "blue"
        case "legendary": return "orange"
        case "special": return "purple"
        default: return "primary"
        }
    }
    
    var typeDisplay: String {
        switch type {
        case "Leader": return "Leaders"
        case "Unit": return "Unité"
        case "Event": return "Événement"
        case "Upgrade": return "Amélioration"
        case "Base": return "Base"
        default: return type
        }
    }

    var aspectDisplay: String {
        guard let aspects = aspects else { return "" }
        let translatedAspects = aspects.map { aspect in
            switch aspect {
            case "Aggression": return "Agressivité"
            case "Command": return "Commandement"
            case "Cunning": return "Ruse"
            case "Heroism": return "Héroïsme"
            case "Vigilance": return "Vigilance"
            case "Villainy": return "Infâmie"
            default: return aspect
            }
        }
        return translatedAspects.joined(separator: " • ")
    }
}