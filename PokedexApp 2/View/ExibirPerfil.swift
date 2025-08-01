//
//  ExibirPerfil.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct ExibirPerfil: View {
    @State var totalCapturados: Int = 0
    @State var pokemonFavorito: PokemonModel?
    
    func carregarDadosPerfil() {
        // carrega o total de capturados
        let idCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        totalCapturados = idCapturados.count
        
        // carrega id do favorito
        if let idFavorito = UserDefaults.standard.object(forKey: "pokemon_favorito_id") as? Int {
            if let pokemonData = UserDefaults.standard.data(forKey: "pokemon_\(idFavorito)"),
               let pokemonModel = try? JSONDecoder().decode(PokemonModel.self, from: pokemonData) {
                self.pokemonFavorito = pokemonModel
            } else {
                self.pokemonFavorito = nil
            }
        } else {
            self.pokemonFavorito = nil
        }

    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Treinador")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.8), radius: 10)
                Text("Treinador Claudinei ")
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Divider()
                HStack(alignment: .top) {
                    VStack {
                        Text("Pokemons Encontrados")
                            .font(.headline)
                            .padding(.bottom, 50)
                        Text("\(totalCapturados)/1302")
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 15) {
                        Text("Pokemon Favorito")
                            .font(.headline)
                        
                        // caso tenha favoritado um pokemon
                        if let favorito = pokemonFavorito {
                            PokemonImage(pokemonId: favorito.id, size: 100).id(favorito.id)
                            Text(favorito.name.capitalized)
                                .font(.subheadline)
                        } else {
                            Text("Nenhum Pokemon favoritado")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 50)
                .padding(.horizontal)
                .navigationTitle("Perfil")
            }
            .task {
                carregarDadosPerfil()
            }
            .onAppear {
                carregarDadosPerfil()
            }
        }
    }
}

#Preview {
    ExibirPerfil()
}

