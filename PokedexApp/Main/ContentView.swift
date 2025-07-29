//
//  ContentView.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemon: Pokemon?
    @State private var input: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            TextField("Digite o nome ou ID do Pokémon", text: $input)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Buscar") {
                Task {
                    await fetchPokemon(by: input)
                }
            }

            if isLoading {
                ProgressView("Carregando...")
            } else if let error = errorMessage {
                Text(error).foregroundColor(.red)
            } else if let pokemon = pokemon {
                VStack(spacing: 10) {
                    Text("\(pokemon.name) (ID: \(pokemon.id))")
                        .font(.title)

                    AsyncImage(url: URL(string: pokemon.sprites.front_default)) { image in
                        image
                            .resizable()
                            .frame(width: 120, height: 120)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }

    func fetchPokemon(by nameOrId: String) async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(nameOrId.lowercased())") else {
            errorMessage = "URL inválida"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let JSONdecodificado = try JSONDecoder().decode(Pokemon.self, from: data)
            self.pokemon = JSONdecodificado
        } catch {
            self.errorMessage = "Erro ao decodificar"
        }

        isLoading = false
    }
}

#Preview {
    ContentView()
}
