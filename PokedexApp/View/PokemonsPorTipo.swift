//
//  PokemonsPorTipo.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct PokemonsPorTipo: View {
    let tipo: NamedAPIResource
    @State private var pokemons: [PokemonListItem] = []

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(pokemons) { pokemon in
                    NavigationLink(destination: PokemonDetalhes(pokemonId: pokemon.id)) {
                        VStack {
                            PokemonImage(pokemonId: pokemon.id, size: 75)
                            Text("#\(pokemon.id)")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text(pokemon.name.capitalized)
                                .font(.caption)
                                .bold()
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(tipo.name.capitalized)
        .task {
            await fetchPokemonsDoTipo()
        }
    }

    func fetchPokemonsDoTipo() async {
        guard let url = URL(string: tipo.url) else {
            print("URL inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonTypeDetail.self, from: data)

            let lista = decoded.pokemon.map { slot in
                PokemonListItem(name: slot.pokemon.name, url: slot.pokemon.url)
            }

            pokemons = lista.sorted { $0.id < $1.id }

        } catch {
            print("Erro ao buscar pokémons do tipo \(tipo.name): \(error.localizedDescription)")
        }
    }
}
