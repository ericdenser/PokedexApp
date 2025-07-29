//
//  PokemonList.swift
//  PokedexApp
//
//  Created by Eric on 29/07/25.
//
import Foundation

struct PokemonListItem: Identifiable, Codable {
    let name: String
    let url: String

    var id: Int {
        if let id = url.split(separator: "/").compactMap({ Int($0) }).last {
            return id
        }
        return -1
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}


