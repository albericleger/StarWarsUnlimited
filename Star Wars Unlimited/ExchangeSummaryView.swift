//
//  ExchangeSummaryView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import SwiftUI

struct ExchangeSummaryView: View {
    @EnvironmentObject private var api: StarWarsUnlimitedAPI
    @StateObject private var player1Manager = ExchangeCardsManager()
    @StateObject private var player2Manager = ExchangePlayer2Manager()

    private var player1Total: Double {
        player1Manager.getTotalPrice(cards: api.cards)
    }

    private var player2Total: Double {
        player2Manager.getTotalPrice(cards: api.cards)
    }

    private var grandTotal: Double {
        player1Total + player2Total
    }

    private var difference: Double {
        abs(player1Total - player2Total)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Résumé de l'échange")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            // Section Joueur 1
            VStack(spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("J1")
                                .font(.headline)
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Joueur 1")
                            .font(.headline)
                        Text("\(player1Manager.totalCards) carte\(player1Manager.totalCards > 1 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(String(format: "%.2f€", player1Total))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }

            // Section Joueur 2
            VStack(spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("J2")
                                .font(.headline)
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Joueur 2")
                            .font(.headline)
                        Text("\(player2Manager.totalCards) carte\(player2Manager.totalCards > 1 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(String(format: "%.2f€", player2Total))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }

            Divider()
                .padding(.vertical, 8)

            // Différence
            if difference > 0 {
                VStack(spacing: 8) {
                    Text("Différence")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f€", difference))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    if player1Total > player2Total {
                        Text("Joueur 1 donne plus")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if player2Total > player1Total {
                        Text("Joueur 2 donne plus")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }

            // Total général
            VStack(spacing: 8) {
                Text("Valeur totale de l'échange")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(String(format: "%.2f€", grandTotal))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .navigationTitle("Résumé")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExchangeSummaryView()
            .environmentObject(StarWarsUnlimitedAPI())
    }
}
