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
            Spacer()
            HStack {
                // Coin inférieur gauche
                NavigationLink(destination: EchangeView2()) {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 70, height: 70)

                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 4)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)

                Spacer()

                // Coin inférieur droit
                NavigationLink(destination: EchangeView2()) {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 70, height: 70)

                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
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
