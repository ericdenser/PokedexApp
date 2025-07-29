//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//

import Foundation

struct PokemonModel: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonTypeEntry]
    let abilities: [PokemonAbilityEntry]
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

// nome e url reutilizavel

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

