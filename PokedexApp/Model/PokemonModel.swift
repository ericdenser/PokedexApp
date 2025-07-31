//
//  PokemonListItem.swift
//  PokedexApp
//
//  Created by Eric on 30/07/25.
//


//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import Foundation

struct PokemonModel: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonTypeEntry]
    let abilities: [PokemonAbilityEntry]
    let stats: [PokemonStat]
    let base_experience: Int? //indicador de raridade
}

// sprites (imagem)
struct PokemonSprites: Codable {
    let front_default: String?
}

// tipos
struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: NamedAPIResource
}

// habilidades
struct PokemonAbilityEntry: Codable {
    let ability: NamedAPIResource
    let is_hidden: Bool
}

// forca
struct PokemonStat: Codable {
    let base_stat: Int
    let stat: NamedAPIResource
}


// nome e url reutilizavel
struct NamedAPIResource: Codable {
    let name: String
    let url: String
}
