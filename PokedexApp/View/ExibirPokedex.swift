import SwiftUI

struct ExibirPokedex: View {
    @State var pokemons: [PokemonListItem] = []
    @State var input: String = ""

    func fetchPokemons() async {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1302") else {
            print("URL inválida")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            pokemons = decoded.results
        } catch {
            print("Erro: \(error.localizedDescription)")
        }
    }

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Pokédex")
                        .font(.largeTitle)
                        .bold()

                    Spacer()

                    TextField("Buscar...", text: $input)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                         .frame(maxWidth: 200)
                }
                .padding([.horizontal, .top])

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredPokemons) { pokemon in
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

    var filteredPokemons: [PokemonListItem] {
        if input.isEmpty {
            return pokemons
        } else {
            return pokemons.filter {
                $0.name.localizedCaseInsensitiveContains(input)
            }
        }
    }
}

#Preview {
    ContentView()
}
