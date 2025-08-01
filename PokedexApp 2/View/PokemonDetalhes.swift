//
//  PokemonDetalhes.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct PokemonDetalhes: View {
    @State var pokemon: PokemonModel?
    @State var capturado: Bool = false
    @State var favorito: Bool = false
    
    let pokemonId: Int
    var pesoFormatado: String {
        let pesoEmKg = Double(pokemon?.weight ?? 0) / 10
        return String(format: "%.1f", pesoEmKg)
    }
    var alturaFormatada: String {
        let alturaEmMetros = Double(pokemon?.height ?? 0) / 10
        return String(format: "%.1f", alturaEmMetros)
    }
    
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
                                    .background(Color.forType(entry.type.name).opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }

                        PokemonImage(pokemonId: pokemon.id, size: 180)
                            .id(capturado)
                        
                        Text(pokemon.name.capitalized)
                            .font(.title)
                            .bold()

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Informações:")
                                    .font(.title)
                                    .foregroundStyle(.primary)
                                    .padding(.top, 15)
                                Text("Altura: \(alturaFormatada) m")
                                Text("Peso: \(pesoFormatado) kg")
                                Text("Força Total: \(forcaTotal)")
                                Text("Raridade (XP Base): \(pokemon.base_experience ?? 0)")
                                Text("Habilidades:")
                                    .font(.title)
                                    .foregroundStyle(.orange)
                                    .padding(.top, 15)

                                ForEach(pokemon.abilities, id: \.ability.name) { ability in
                                    Text("• \(ability.ability.name.capitalized)")
                                }
                            }
                            .bold()
                            .font(.headline)
                        

                            Spacer()
                        }

                        Spacer()
                    }
                    
                    VStack(spacing: 20) {
                        // capturar
                        Button(action: {
                            capturarPokemon()
                        }) {
                            Image("Pokebola")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .colorMultiply(capturado ? .red : .gray)
                        }
                        .disabled(capturado)
                        
                        // favoritar
                        Button(action: {
                            toggleFavorito()
                        }) {
                            Image(systemName: favorito ? "star.fill" : "star")
                                .foregroundColor(favorito ? .yellow : .gray)
                                .font(.title)
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
        .task {
            await fetchPokemon()
            verificarCapturado()
            verificarFavorito()
        }
    }
    
 

    func toggleFavorito() {
        if favorito {
            // remove se ja for favorito
            UserDefaults.standard.removeObject(forKey: "pokemon_favorito_id")
            self.favorito = false
        } else {
            // favorita
            UserDefaults.standard.set(pokemonId, forKey: "pokemon_favorito_id")
            self.favorito = true
        }
    }
    
    
    func verificarFavorito() {
        let idFavorito = UserDefaults.standard.integer(forKey: "pokemon_favorito_id")
        if idFavorito == pokemonId {
            self.favorito = true
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
