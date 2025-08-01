//
//  ExibirPokedex.swift
//  PokedexApp
//
//  Created by Aluno Mack on 29/07/25.
//
import SwiftUI

struct ExibirPokedex: View {
    @State var input: String = ""
    
    @State var pokemons: [PokemonListItem] = []

    func fetchPokemons() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1302") else {
            print("URL inválida")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodificado = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            pokemons = decodificado.results
        } catch {
            print("Erro: \(error.localizedDescription)")
        }
    }

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Pkédex")
                        .font(.largeTitle)
                        .bold()

                    Spacer()

                    TextField("Buscar...", text: $input)
                         .fontWeight(.bold)
                         .padding(8)
                         .frame(maxWidth: 200)
                         .overlay(
                                 RoundedRectangle(cornerRadius: 8)
                                     .stroke(Color.black, lineWidth: 1) 
                             )
                         .autocorrectionDisabled(true)
                }
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(pokemonsFiltrados) { pokemon in
                            NavigationLink(destination: PokemonDetalhes(pokemonId: pokemon.id)) {
                                VStack {
                                    PokemonImage(pokemonId: pokemon.id, size: 75)

                                    Text("#\(pokemon.id)")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)

                                    Text(pokemon.name.capitalized)
                                        .font(.caption)
                                        .bold()
                                        .foregroundStyle(.primary)
                                }
                                .frame(maxHeight: 120)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding()
                }
            }
            .task {
                await fetchPokemons()
            }
        }
    }

    var pokemonsFiltrados: [PokemonListItem] {
        if input.isEmpty {
            return pokemons
        } else {
            return pokemons.filter {
                $0.name.localizedCaseInsensitiveContains(input)
            }
        }
    }
}

