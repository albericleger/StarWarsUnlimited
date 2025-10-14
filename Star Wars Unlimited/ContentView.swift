//
//  ContentView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 14/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var api = StarWarsUnlimitedAPI()
    @State private var searchText = ""
    @State private var selectedCard: Card?
    @State private var showingCardDetail = false
    @State private var selectedFilters: Set<FilterOption> = []
    @State private var selectedSets: Set<SetOption> = []
    @State private var selectedAspects: Set<AspectOption> = []
    @State private var showingFilterSheet = false

    enum FilterOption: String, CaseIterable, Hashable {
        case leaders = "Leaders"
        case units = "Unités"
        case events = "Événements"
        case upgrades = "Améliorations"
        case bases = "Bases"

        var apiFilter: String {
            switch self {
            case .leaders: return "Leader"
            case .units: return "Unit"
            case .events: return "Event"
            case .upgrades: return "Upgrade"
            case .bases: return "Base"
            }
        }
    }

    enum SetOption: String, CaseIterable, Hashable {
        case sor = "SOR"
        case shd = "SHD"
        case twi = "TWI"
        case jtl = "JTL"
        case lof = "LOF"
        case ibh = "IBH"

        var fullName: String {
            switch self {
            case .sor: return "L'Étincelle de la Rébellion"
            case .shd: return "Les Ombres de la Galaxie"
            case .twi: return "Le Crépuscule de la République"
            case .jtl: return "Saut vers la Vitesse Lumière"
            case .lof: return "Le Repaire du Père"
            case .ibh: return "Glace et Trahison"
            }
        }
    }

    enum AspectOption: String, CaseIterable, Hashable {
        case aggression = "Aggression"
        case command = "Command"
        case cunning = "Cunning"
        case heroism = "Heroism"
        case vigilance = "Vigilance"
        case villainy = "Villainy"

        var displayName: String {
            switch self {
            case .aggression: return "🔴 Agressivité"
            case .command: return "🟢 Commandement"
            case .cunning: return "🟡 Ruse"
            case .heroism: return "🔵 Héroïsme"
            case .vigilance: return "⚪️ Vigilance"
            case .villainy: return "⚫️ Vilenie"
            }
        }
    }

    private let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 16)
    ]
    
    var filteredCards: [Card] {
        var cards = api.cards

        // Filtrage par sets (si des sets sont sélectionnés)
        if !selectedSets.isEmpty {
            cards = cards.filter { card in
                selectedSets.contains(where: { $0.rawValue == card.set })
            }
        }

        // Filtrage par aspects (couleurs)
        if !selectedAspects.isEmpty {
            cards = cards.filter { card in
                guard let cardAspects = card.aspects else { return false }
                return selectedAspects.contains(where: { aspect in
                    cardAspects.contains(aspect.rawValue)
                })
            }
        }

        // Filtrage par types
        if !selectedFilters.isEmpty {
            cards = cards.filter { card in
                selectedFilters.contains(where: { $0.apiFilter == card.type })
            }
        }

        // Filtrage par recherche
        if !searchText.isEmpty {
            cards = cards.filter { card in
                card.name.localizedCaseInsensitiveContains(searchText) ||
                card.subtitle?.localizedCaseInsensitiveContains(searchText) == true ||
                (card.traits?.joined(separator: " ").localizedCaseInsensitiveContains(searchText) == true) ||
                (card.aspects?.joined(separator: " ").localizedCaseInsensitiveContains(searchText) == true)
            }
        }

        return cards
    }

    var activeFiltersCount: Int {
        selectedSets.count + selectedAspects.count + selectedFilters.count
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Barre de recherche et bouton filtres
                HStack(spacing: 12) {
                    SearchBar(text: $searchText)

                    Button(action: {
                        showingFilterSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title2)
                            if activeFiltersCount > 0 {
                                Text("\(activeFiltersCount)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding()

                // Contenu principal
                if api.isLoading {
                    Spacer()
                    ProgressView("Chargement des cartes...")
                        .font(.headline)
                    Spacer()
                } else if let errorMessage = api.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        Text("Erreur")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Réessayer") {
                            Task {
                                await api.fetchAllCards()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                } else if filteredCards.isEmpty && !api.cards.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Aucun résultat")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Aucune carte ne correspond à votre recherche")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Grille des cartes
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredCards) { card in
                                CardView(card: card)
                                    .onTapGesture {
                                        selectedCard = card
                                        showingCardDetail = true
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Star Wars Unlimited")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await api.fetchAllCards()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(api.isLoading)
                }
            }
        }
        .task {
            if api.cards.isEmpty {
                await api.fetchAllCards()
            }
        }
        .sheet(isPresented: $showingCardDetail) {
            if let card = selectedCard {
                CardDetailView(card: card)
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(
                selectedSets: $selectedSets,
                selectedAspects: $selectedAspects,
                selectedFilters: $selectedFilters
            )
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Rechercher des cartes...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSets: Set<ContentView.SetOption>
    @Binding var selectedAspects: Set<ContentView.AspectOption>
    @Binding var selectedFilters: Set<ContentView.FilterOption>

    var body: some View {
        NavigationView {
            List {
                // Section Sets
                Section("Extensions") {
                    ForEach(ContentView.SetOption.allCases, id: \.self) { set in
                        MultiSelectRow(
                            title: set.rawValue,
                            subtitle: set.fullName,
                            isSelected: selectedSets.contains(set)
                        ) {
                            if selectedSets.contains(set) {
                                selectedSets.remove(set)
                            } else {
                                selectedSets.insert(set)
                            }
                        }
                    }
                }

                // Section Aspects (Couleurs)
                Section("Aspects") {
                    ForEach(ContentView.AspectOption.allCases, id: \.self) { aspect in
                        MultiSelectRow(
                            title: aspect.displayName,
                            subtitle: nil,
                            isSelected: selectedAspects.contains(aspect)
                        ) {
                            if selectedAspects.contains(aspect) {
                                selectedAspects.remove(aspect)
                            } else {
                                selectedAspects.insert(aspect)
                            }
                        }
                    }
                }

                // Section Types
                Section("Types de cartes") {
                    ForEach(ContentView.FilterOption.allCases, id: \.self) { filter in
                        MultiSelectRow(
                            title: filter.rawValue,
                            subtitle: nil,
                            isSelected: selectedFilters.contains(filter)
                        ) {
                            if selectedFilters.contains(filter) {
                                selectedFilters.remove(filter)
                            } else {
                                selectedFilters.insert(filter)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filtres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Réinitialiser") {
                        selectedSets.removeAll()
                        selectedAspects.removeAll()
                        selectedFilters.removeAll()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MultiSelectRow: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
