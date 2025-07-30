import SwiftUI

struct PokemonImage: View {
    var pokemonId: Int
    var size: CGFloat = 75

    @State var pokemonSprite: String = ""

    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .saturation(0.0)
            case .failure(_):
                ProgressView()
            default:
                ProgressView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .onAppear {
            loadSprite()
        }
    }

    func loadSprite() {
        let key = "sprite_url_\(pokemonId)"
        if let cachedURL = UserDefaults.standard.string(forKey: key) {
            self.pokemonSprite = cachedURL
        } else {
            Task {
                if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"),
                   let (data, _) = try? await URLSession.shared.data(from: url),
                   let decoded = try? JSONDecoder().decode(PokemonModel.self, from: data),
                   let spriteURL = decoded.sprites.front_default {
                    
                    UserDefaults.standard.set(spriteURL, forKey: key)
                    self.pokemonSprite = spriteURL
                } else {
                    self.pokemonSprite = ""
                }
            }
        }
    }
}
