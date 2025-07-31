//
//  PokemonDetalhes.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct PokemonDetalhes: View {
    let pokemonId: Int
    @State var pokemon: PokemonModel?
    @State var capturado: Bool = false
    var forcaTotal: Int {
        pokemon?.stats.reduce(0) { somaParcial, statAtual in
            return somaParcial + statAtual.base_stat
        } ?? 0
    }

    var body: some View {
        VStack {
            if let pokemon = pokemon {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 16) {
                        HStack {
                            ForEach(pokemon.types, id: \.slot) { entry in
                                Text(entry.type.name.capitalized)
                                    .font(.subheadline)
                                    .padding(6)
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }

                        PokemonImage(pokemonId: pokemon.id, size: 180)
                            .id(capturado)
                        
                        Text(pokemon.name.capitalized)
                            .font(.title)
                            .bold()

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Altura: \(Double(pokemon.height) / 10, specifier: "%.1f") m")
                            
                            Text("Peso: \(Double(pokemon.weight) / 10, specifier: "%.1f") kg")
                            
                            Text("Força Total: \(forcaTotal)")
                                .fontWeight(.medium)
                            
                            Text("Raridade (XP Base): \(pokemon.base_experience ?? 0)")
                                .fontWeight(.medium)
                            
                            Text("Habilidades:")
                                .font(.headline)
                                .padding(.top, 8)
    
                            ForEach(pokemon.abilities, id: \.ability.name) { ability in
                                Text("• \(ability.ability.name.capitalized)")
                            }
                        }

                        Spacer()
                    }
                    
                    Button(action: {
                        capturarPokemon()
                    }) {
                        Image("Pokebola")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .colorMultiply(capturado ? .red : .gray)
                    }
                    .padding()
                    .disabled(capturado)
                }
                .padding()
            }
        }
        .task {
            await fetchPokemon()
            verificarCapturado()
        }
    }
    
    func capturarPokemon() {
        var listaCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        
        if !listaCapturados.contains(pokemonId) {
            listaCapturados.append(pokemonId)
            UserDefaults.standard.set(listaCapturados, forKey: "pokemons_capturados")
            self.capturado = true
        }
    }
    
    func verificarCapturado() {
        let listaCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        if listaCapturados.contains(pokemonId) {
            self.capturado = true
        }
    }

    func fetchPokemon() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)") else {
            print ("URL inválida")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodificado = try JSONDecoder().decode(PokemonModel.self, from: data)
            pokemon = decodificado
            
            UserDefaults.standard.set(data, forKey: "pokemon_\(pokemonId)")
            
        } catch {
            print ("Erro: \(error.localizedDescription)")
        }
    }
}
