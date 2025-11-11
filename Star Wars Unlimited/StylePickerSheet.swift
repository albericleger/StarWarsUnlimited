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
                        HStack {
                            Text(style.icon)
                                .font(.title2)
                            Text(style.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            if style == currentStyle {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Style de carte")
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
}
