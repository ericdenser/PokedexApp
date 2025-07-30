//
//  PokemonTipo.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import Foundation

struct TypeListResponse: Codable {
    let results: [NamedAPIResource]
}

struct PokemonTypeDetail: Codable {
    let pokemon: [PokemonTypeSlot]
}

struct PokemonTypeSlot: Codable {
    let pokemon: NamedAPIResource
}
