//
//  EchangeView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import SwiftUI

struct EchangeView: View {
    var body: some View {
        VStack {
            // Bouton résumé au centre en haut
            NavigationLink(destination: ExchangeSummaryView()) {
                HStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .font(.headline)
                    Text("Voir le résumé")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.purple)
                .cornerRadius(25)
                .shadow(radius: 4)
            }
            .padding(.top, 40)

            Spacer()

            HStack {
                // Coin inférieur gauche - Joueur 1
                NavigationLink(destination: EchangeView2()) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 70, height: 70)

                        VStack(spacing: 2) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("J1")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .shadow(radius: 4)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)

                Spacer()

                // Coin inférieur droit - Joueur 2
                NavigationLink(destination: EchangeView3()) {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 70, height: 70)

                        VStack(spacing: 2) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("J2")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    EchangeView()
}
