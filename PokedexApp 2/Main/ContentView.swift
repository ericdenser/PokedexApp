//
//  ContentView.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExibirPokedex()
                .tabItem {
                    Label("Pokédex", systemImage: "list.dash")
            }

            ExibirEstatisticas()
                .tabItem {
                    Label("Estatísticas", systemImage: "chart.bar.xaxis")
            }

            ExibirPerfil()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}

