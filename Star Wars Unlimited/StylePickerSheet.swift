//
//  StylePickerSheet.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 10/11/2025.
//

import SwiftUI

struct StylePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let card: Card
    let currentStyle: CardStyle
    let onStyleSelected: (CardStyle) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(CardStyle.allCases, id: \.self) { style in
                    Button(action: {
                        onStyleSelected(style)
                    }) {
                        HStack(spacing: 16) {
                            Text(style.icon)
                                .font(.system(size: 28))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(style.rawValue)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                    .fontWeight(.medium)

                                Text(styleDescription(for: style))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if style == currentStyle {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.primaryGreen)
                                    .font(.title3)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.darkBackground)
            .navigationTitle("Style de carte")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryBlue)
                }
            }
        }
    }

    private func styleDescription(for style: CardStyle) -> String {
        switch style {
        case .normal:
            return "Version standard"
        case .hyperspace:
            return "Edition Hyperspace"
        case .showcase:
            return "Version alternative"
        case .foil:
            return "Version premium"
        }
    }
}
