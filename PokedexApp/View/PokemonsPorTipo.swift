//
//  PokemonsPorTipo.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct PokemonsPorTipo: View {
    let tipo: NamedAPIResource
    @State var pokemonsCapturados: [PokemonModel] = []
    @State var totalPokemonsTipo: Int = 0
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    // Calcula mais forte baseado na soma dos stats base
    var pokemonMaisForte: PokemonModel? {
        pokemonsCapturados.max { p1, p2 in
            let sum1 = p1.stats.reduce(0) { somaParcial, itemAtual in
                return somaParcial + itemAtual.base_stat
            }
            let sum2 = p2.stats.reduce(0) { somaParcial, itemAtual in
                return somaParcial + itemAtual.base_stat
            }
            return sum1 < sum2
        }
    }
    
    // Calcula o mais "raro" baseado na experiência base
    var pokemonMaisRaro: PokemonModel? {
        pokemonsCapturados.max { pokemon1, pokemon2 in
            let xp1 = pokemon1.base_experience ?? 0
            let xp2 = pokemon2.base_experience ?? 0
            
            return xp1 < xp2
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            
            // LADO ESQUERDO
            VStack(alignment: .leading, spacing: 20) {
                Text("Estatísticas")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom)

                Text("Total Capturado:")
                    .font(.headline)
                Text("\(pokemonsCapturados.count) / \(totalPokemonsTipo)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                if let maisRaro = pokemonMaisRaro {
                    Text("Mais Raro Capturado:")
                        .font(.headline)
                        .padding(.top)
                    HStack {
                        PokemonImage(pokemonId: maisRaro.id, size: 40)
                        Text(maisRaro.name.capitalized)
                    }
                }
                
                if let maisForte = pokemonMaisForte {
                    Text("Mais Forte Capturado:")
                        .font(.headline)
                        .padding(.top)
                    HStack {
                        PokemonImage(pokemonId: maisForte.id, size: 40)
                        Text(maisForte.name.capitalized)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // LADO DIREITO
            ScrollView {
                if pokemonsCapturados.isEmpty {
                    Text("Capture Pokémon deste tipo para ver as estatísticas.")
                        .foregroundColor(.gray)
                        .padding(50)
                        .multilineTextAlignment(.center)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(pokemonsCapturados) { pokemon in
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
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(tipo.name.capitalized)
        .task {
            await fetchDadosDoTipo()
        }
    }
    

    func fetchDadosDoTipo() async {
        
        guard let url = URL(string: tipo.url) else { return }

        do {
            // total de pokemons de cada tipo
            let (data, _) = try await URLSession.shared.data(from: url)
            let tipoDecodificado = try JSONDecoder().decode(PokemonTypeDetail.self, from: data)
            self.totalPokemonsTipo = tipoDecodificado.pokemon.count

            //carregar ids capturados
            let idCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
            
            var listaCapturados: [PokemonModel] = []
            
            for id in idCapturados {
                if let pokemonData = UserDefaults.standard.data(forKey: "pokemon_\(id)"),
                   let pokemonModel = try? JSONDecoder().decode(PokemonModel.self, from: pokemonData) {
                    
                    // verificar se pertence a este tipo
                    let temTipo = pokemonModel.types.contains { entry in
                        return entry.type.name == self.tipo.name
                    }
                    if temTipo {
                        listaCapturados.append(pokemonModel)
                    }
                }
            }

            self.pokemonsCapturados = listaCapturados.sorted { p1, p2 in
                return p1.id < p2.id
            }

        } catch {
            print("Erro ao buscar dados do tipo \(tipo.name): \(error.localizedDescription)")
        }
    }
}
