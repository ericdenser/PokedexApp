//
//  ExibirEstatisticas.swift
//  APPPOKEDEX
//
//  Created by Eric on 30/07/25.
//

import SwiftUI

struct ExibirEstatisticas: View {
    @State var tipos: [NamedAPIResource] = []
    @State var totalCapturados: Int = 0

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Total Capturado")
                            .font(.headline)
                        Spacer()
                        Text("\(totalCapturados)/1302")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Tipos")) {
                    ForEach(tipos, id: \.name) { tipo in
                        NavigationLink(destination: PokemonsPorTipo(tipo: tipo)) {
                            Label(
                                title: { Text(tipo.name.capitalized).fontWeight(.bold) },
                                icon: {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(Color.forType(tipo.name))
                                }
                            )
                        }
                        .listRowBackground(Color.forType(tipo.name).opacity(0.2))
                    }
                }
            }
            .task {
                await fetchTipos()
                carregarCapturados()
            }
        }
    }
    
    func carregarCapturados() {
        let idCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        self.totalCapturados = idCapturados.count
    }

    func fetchTipos() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type") else {
            print("URL de tipos inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodificado = try JSONDecoder().decode(TypeListResponse.self, from: data)
            self.tipos = decodificado.results
        } catch {
            print("Erro ao buscar os tipos: \(error.localizedDescription)")
        }
    }
}
