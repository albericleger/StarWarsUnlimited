//
//  FilterManager.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 11/11/2025.
//

import Combine
import Foundation

struct SavedFilters: Codable {
    var selectedTypes: [String]
    var selectedSets: [String]
    var selectedAspects: [String]
}

class FilterManager: ObservableObject {
    @Published var selectedTypes: Set<String> = []
    @Published var selectedSets: Set<String> = []
    @Published var selectedAspects: Set<String> = []

    private let userDefaultsKey = "savedFilters"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        loadFilters()
    }

    // Charger les filtres depuis UserDefaults
    func loadFilters() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey)
        else {
            print("📁 Aucun filtre sauvegardé")
            return
        }

        do {
            let savedFilters = try decoder.decode(SavedFilters.self, from: data)
            selectedTypes = Set(savedFilters.selectedTypes)
            selectedSets = Set(savedFilters.selectedSets)
            selectedAspects = Set(savedFilters.selectedAspects)
            print(
                "✅ Chargé \(selectedTypes.count) types, \(selectedSets.count) sets, \(selectedAspects.count) aspects"
            )
        } catch {
            print(
                "❌ Erreur lors du chargement des filtres: \(error.localizedDescription)"
            )
        }
    }

    // Sauvegarder les filtres dans UserDefaults
    func saveFilters() {
        let savedFilters = SavedFilters(
            selectedTypes: Array(selectedTypes),
            selectedSets: Array(selectedSets),
            selectedAspects: Array(selectedAspects)
        )

        do {
            let data = try encoder.encode(savedFilters)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            print(
                "💾 Filtres sauvegardés: \(selectedTypes.count) types, \(selectedSets.count) sets, \(selectedAspects.count) aspects"
            )
        } catch {
            print(
                "❌ Erreur lors de la sauvegarde des filtres: \(error.localizedDescription)"
            )
        }
    }

    // Mettre à jour les types
    func updateTypes(_ types: Set<String>) {
        selectedTypes = types
        saveFilters()
    }

    // Mettre à jour les sets
    func updateSets(_ sets: Set<String>) {
        selectedSets = sets
        saveFilters()
    }

    // Mettre à jour les aspects
    func updateAspects(_ aspects: Set<String>) {
        selectedAspects = aspects
        saveFilters()
    }

    // Réinitialiser tous les filtres
    func clearAll() {
        selectedTypes.removeAll()
        selectedSets.removeAll()
        selectedAspects.removeAll()
        saveFilters()
    }

    // Nombre total de filtres actifs
    var activeFiltersCount: Int {
        selectedTypes.count + selectedSets.count + selectedAspects.count
    }
}
