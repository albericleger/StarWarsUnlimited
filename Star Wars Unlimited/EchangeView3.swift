//
//  EchangeView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 15/11/2025.
//

import SwiftUI

struct EchangeView3: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @EnvironmentObject private var exchangePlayer2Manager: ExchangePlayer2Manager
    @EnvironmentObject private var filterManager: FilterManager
    @State private var searchText = ""
    @State private var selectedCard: Card?
    @State private var showingCardDetail = false
    @State private var selectedFilters: Set<FilterOption> = [.leaders]
    @State private var selectedSets: Set<SetOption> = []
    @State private var selectedAspects: Set<AspectOption> = []
    @State private var showingFilterSheet = false
    @State private var showingStylePicker = false
    @State private var cardForStyleChange: Card?
    @State private var showingPriceSheet = false

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
        case sec = "SEC"
        case ibh = "IBH"
        case lof = "LOF"
        case jtl = "JTL"
        case twi = "TWI"
        case shd = "SHD"
        case sor = "SOR"

        var fullName: String {
            switch self {
            case .sec: return "Secret du Pouvoir"
            case .sor: return "Étincelle de la Rébellion"
            case .shd: return "Les Ombres de la Galaxie"
            case .twi: return "Crépuscule de la République"
            case .jtl: return "Passage Vitesse Lumière"
            case .lof: return "Légende de la force"
            case .ibh: return "Combat d'introduction:Hot"
            }
        }
    }

    enum AspectOption: String, CaseIterable, Hashable {
        case aggression = "Agressivité"
        case command = "Commandement"
        case cunning = "Ruse"
        case heroism = "Heroïsme"
        case vigilance = "Vigilance"
        case villainy = "Infâmie"

        var displayName: String {
            switch self {
            case .aggression: return "🔴 Agressivité"
            case .command: return "🟢 Commandement"
            case .cunning: return "🟡 Ruse"
            case .heroism: return "🔵 Héroïsme"
            case .vigilance: return "⚪️ Vigilance"
            case .villainy: return "⚫️ Infâmie"
            }
        }
    }

    private let columns = [
        GridItem(.adaptive(minimum: 180), spacing: 16)
    ]

    // Charger les filtres sauvegardés
    private func loadSavedFilters() {
        selectedFilters = Set(filterManager.selectedTypes.compactMap { typeString in
            FilterOption.allCases.first { $0.apiFilter == typeString }
        })

        selectedSets = Set(filterManager.selectedSets.compactMap { setString in
            SetOption.allCases.first { $0.rawValue == setString }
        })

        selectedAspects = Set(filterManager.selectedAspects.compactMap { aspectString in
            AspectOption.allCases.first { $0.rawValue == aspectString }
        })
    }

    // Sauvegarder les filtres
    private func saveFilters() {
        filterManager.updateTypes(Set(selectedFilters.map { $0.apiFilter }))
        filterManager.updateSets(Set(selectedSets.map { $0.rawValue }))
        filterManager.updateAspects(Set(selectedAspects.map { $0.rawValue }))
    }

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
        VStack(spacing: 0) {
                // Barre de recherche et bouton filtres
                HStack(spacing: 12) {
                    EchangeSearchBar3(text: $searchText)

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
                                    .background(AppTheme.accentOrange)
                                    .clipShape(Circle())
                            }
                        }
                        .foregroundColor(AppTheme.primaryBlue)
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
                            .foregroundColor(AppTheme.accentOrange)
                        Text("Erreur")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button(action: {
                            Task {
                                await api.fetchAllCards()
                            }
                        }) {
                            Text("Réessayer")
                        }
                        .primaryButtonStyle()
                    }
                    .padding()
                    Spacer()
                } else if filteredCards.isEmpty && !api.cards.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(AppTheme.primaryBlue.opacity(0.5))
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
                                CardView(
                                    card: card,
                                    isChecked: exchangePlayer2Manager.isChecked(card.id),
                                    quantity: exchangePlayer2Manager.getQuantity(card.id),
                                    style: exchangePlayer2Manager.getStyle(card.id),
                                    onInfoTap: {
                                        selectedCard = card
                                        showingCardDetail = true
                                    },
                                    onIncrement: {
                                        exchangePlayer2Manager.incrementQuantity(card.id)
                                    },
                                    onDecrement: {
                                        exchangePlayer2Manager.decrementQuantity(card.id)
                                    },
                                    onStyleTap: {
                                        cardForStyleChange = card
                                        showingStylePicker = true
                                    }
                                )
                                .onTapGesture {
                                    // Tap sur la carte : cocher/décocher
                                    if !exchangePlayer2Manager.isChecked(card.id) {
                                        exchangePlayer2Manager.toggleCard(card.id)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Joueur 2")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    if !exchangePlayer2Manager.checkedCards.isEmpty {
                        Menu {
                            Button(action: {
                                showingPriceSheet = true
                            }) {
                                Label("Voir les prix détaillés", systemImage: "dollarsign.circle")
                            }

                            Divider()

                            Button(role: .destructive, action: {
                                exchangePlayer2Manager.clearAll()
                            }) {
                                Label("Tout supprimer", systemImage: "trash")
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("\(exchangePlayer2Manager.totalCards) carte\(exchangePlayer2Manager.totalCards > 1 ? "s" : "")")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }

                                let totalPrice = exchangePlayer2Manager.getTotalPrice(cards: api.cards)
                                if totalPrice > 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "dollarsign.circle.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        Text(String(format: "%.2f€", totalPrice))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                        }
                    }
                }

                ToolbarItem(placement: .automatic) {
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
        .sheet(isPresented: $showingCardDetail) {
            if let card = selectedCard {
                CardDetailView(card: card)
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            EchangeFilterSheet3(
                selectedSets: $selectedSets,
                selectedAspects: $selectedAspects,
                selectedFilters: $selectedFilters
            )
        }
        .sheet(isPresented: $showingStylePicker) {
            if let card = cardForStyleChange {
                StylePickerSheet(
                    card: card,
                    currentStyle: exchangePlayer2Manager.getStyle(card.id),
                    onStyleSelected: { newStyle in
                        exchangePlayer2Manager.setStyle(card.id, style: newStyle)
                        showingStylePicker = false
                    }
                )
            }
        }
        .sheet(isPresented: $showingPriceSheet) {
            ExchangePriceBreakdownSheet(manager: exchangePlayer2Manager)
        }
        .onAppear {
            loadSavedFilters()
        }
        .onChange(of: showingFilterSheet) { _, isShowing in
            if !isShowing {
                // Sauvegarder quand la feuille de filtres se ferme
                saveFilters()
            }
        }
    }
}

struct EchangeSearchBar3: View {
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
        .background(AppTheme.searchBarBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall))
    }
}

struct EchangeFilterSheet3: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSets: Set<EchangeView3.SetOption>
    @Binding var selectedAspects: Set<EchangeView3.AspectOption>
    @Binding var selectedFilters: Set<EchangeView3.FilterOption>

    var body: some View {
        NavigationStack {
            List {
                // Section Sets
                Section {
                    ForEach(EchangeView3.SetOption.allCases, id: \.self) { set in
                        EchangeMultiSelectRow3(
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
                } header: {
                    Text("Extensions")
                        .foregroundColor(AppTheme.primaryBlue)
                        .fontWeight(.semibold)
                }

                // Section Aspects (Couleurs)
                Section {
                    ForEach(EchangeView3.AspectOption.allCases, id: \.self) { aspect in
                        EchangeMultiSelectRow3(
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
                } header: {
                    Text("Aspects")
                        .foregroundColor(AppTheme.primaryBlue)
                        .fontWeight(.semibold)
                }

                // Section Types
                Section {
                    ForEach(EchangeView3.FilterOption.allCases, id: \.self) { filter in
                        EchangeMultiSelectRow3(
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
                } header: {
                    Text("Types de cartes")
                        .foregroundColor(AppTheme.primaryBlue)
                        .fontWeight(.semibold)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.darkBackground)
            .navigationTitle("Filtres")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Réinitialiser") {
                        selectedSets.removeAll()
                        selectedAspects.removeAll()
                        selectedFilters.removeAll()
                    }
                    .foregroundColor(AppTheme.accentOrange)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
    }
}

struct EchangeMultiSelectRow3: View {
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
                        .foregroundColor(AppTheme.primaryGreen)
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EchangeView3()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(FilterManager())
            .environmentObject(ExchangePlayer2Manager())
    }
}
