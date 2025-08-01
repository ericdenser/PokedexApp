//
//  PokemonImage.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import SwiftUI

struct PokemonImage: View {
    var pokemonId: Int
    var size: CGFloat = 75

    @State var pokemonSprite: String = ""
    @State var foiCapturado: Bool = false

    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .saturation(foiCapturado ? 1.0 : 0.0)
            case .failure(_):
                ProgressView()
            default:
                ProgressView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .onAppear {
            // a imagem aparece, busca o sprite e verifica o status
            carregarSprite()
            verificarCapturado()
        }
    }
    

    func verificarCapturado() {
        let listaCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        
        if listaCapturados.contains(pokemonId) {
            self.foiCapturado = true
        } else {
            self.foiCapturado = false
        }
    }

    func carregarSprite() {
        let key = "sprite_url_\(pokemonId)"
        if let cachedURL = UserDefaults.standard.string(forKey: key) {
            self.pokemonSprite = cachedURL
        } else {
            Task {
                if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)"),
                   let (data, _) = try? await URLSession.shared.data(from: url),
                   let decodificado = try? JSONDecoder().decode(PokemonModel.self, from: data),
                   let spriteURL = decodificado.sprites.front_default {
                    
                    UserDefaults.standard.set(spriteURL, forKey: key)
                    self.pokemonSprite = spriteURL
                } else {
                    self.pokemonSprite = ""
                }
            }
        }
    }
}
