//
//  EchangeView.swift
//  Star Wars Unlimited
//
//  Created by Albéric Léger on 16/11/2025.
//

import SwiftUI

struct EchangeView: View {
    var body: some View {
        Spacer()
        NavigationLink(destination: EchangeView2()) {
            Text("Ajouter des cartes")
                
        }
    }
}

#Preview {
    EchangeView()
}
