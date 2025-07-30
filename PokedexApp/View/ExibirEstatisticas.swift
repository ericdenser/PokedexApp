//
//  ExibirEstatisticas.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct ExibirEstatisticas: View {
    @State private var tipoContagem: [String: Int] = [:]

    var body: some View {
        NavigationStack {
            List(tipoContagem.sorted(by: { $0.value > $1.value }), id: \.key) { tipo, quantidade in
                HStack {
                    Text(tipo.capitalized)
                    Spacer()
                    Text("\(quantidade)")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Estatísticas")
            .onAppear {
                carregarTipos()
            }
        }
    }

    func carregarTipos() {
        var tipos: [String: Int] = [:]

        for id in 1...1302 {
            if let data = UserDefaults.standard.data(forKey: "pokemon_\(id)"),
               let pokemon = try? JSONDecoder().decode(PokemonModel.self, from: data) {
                for tipo in pokemon.types {
                    tipos[tipo.type.name, default: 0] += 1
                }
            }
        }

        self.tipoContagem = tipos
    }
}

