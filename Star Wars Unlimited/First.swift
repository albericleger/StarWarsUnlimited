//
//  First.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 18/10/2025.
//

import SwiftUI

struct First: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Star Wars Unlimited")
                .font(.largeTitle)
                .fontWeight(.bold)

            NavigationLink(destination: ContentView()) {
                Text("Parcourir les Cartes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            NavigationLink(destination: ClasseurView()) {
                Text("Parcourir les Classeurs")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        First()
            .environmentObject(StarWarsUnlimitedAPI())
            .environmentObject(CheckedCardsManager())
    }
}
