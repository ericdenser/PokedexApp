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
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 16) {
                        // Tipos do Pokémon em cima da imagem
                        HStack {
                            ForEach(pokemon.types, id: \.slot) { entry in
                                Text(entry.type.name.capitalized)
                                    .font(.subheadline)
                                    .padding(6)
                                    .background(.orange.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }

                        // Imagem e nome
                        PokemonImage(pokemonId: pokemon.id, size: 180)
                        Text(pokemon.name.capitalized)
                            .font(.title)
                            .bold()

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Altura: \(Double(pokemon.height) / 10, specifier: "%.1f") m")
                            Text("Peso: \(Double(pokemon.weight) / 10, specifier: "%.1f") kg")
                            Text("Habilidades:")
                                .font(.headline)
                            ForEach(pokemon.abilities, id: \.ability.name) { ability in
                                Text("• \(ability.ability.name.capitalized)")
                            }
                        }

                        Spacer()
                    }

                    // Pokébola para desbloquear
//                    Button(action: {
//                        isUnlocked.toggle()
//                        saveUnlockedStatus()
//                    }) {
//                        Image("Pokebola")
//                            .resizable()
//                            .frame(width: 32, height: 32)
//                            .padding(12)
//                    }
                }
                .padding()
            }
        }
        .task {
            await fetchPokemon()
//            loadUnlockedStatus()
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
            
            UserDefaults.standard.set(data, forKey: "pokemon_\(pokemonId)")
            
        } catch {
            print ("Erro: \(error.localizedDescription)")
        }
    }

//    func saveUnlockedStatus() {
//        UserDefaults.standard.set(isUnlocked, forKey: "unlocked_\(pokemonId)")
//    }
//
//    func loadUnlockedStatus() {
//        isUnlocked = UserDefaults.standard.bool(forKey: "unlocked_\(pokemonId)")
//    }
}


