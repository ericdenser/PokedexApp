//
//  PokemonImage.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct PokemonDetalhes: View {
    let pokemonId: Int
    @State var pokemon: PokemonModel?

    var body: some View {
        VStack {
            if let pokemon = pokemon {
                VStack(spacing: 16) {
                    Text(pokemon.name.capitalized)
                        .font(.largeTitle)
                        .bold()

                    PokemonImage(pokemonId: pokemon.id, size: 180)

                    Text("Altura: \(Double(pokemon.height) / 10, specifier: "%.1f") m")
                    Text("Peso: \(Double(pokemon.weight) / 10, specifier: "%.1f") kg")
                }
                .padding()
                HStack {
                    ForEach(pokemon.types, id: \.slot) { entry in
                        Text(entry.type.name.capitalized)
                            .padding(6)
                            .background(.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Habilidades:")
                        .font(.headline)

                    ForEach(pokemon.abilities, id: \.ability.name) { ability in
                        Text("• \(ability.ability.name.capitalized)")
                    }
                }
            }
        }
        .task {
            await fetchPokemon()
        }
    }

    func fetchPokemon() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)") else {
            print ("URL inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonModel.self, from: data)
            pokemon = decoded
        } catch {
            print ("Erro: \(error.localizedDescription)")
        }

    }
}

