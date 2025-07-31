//
//  ExibirPerfil.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct ExibirPerfil: View {
    @State var totalCapturados: Int = 0
    
    func carregarCapturados() {
        let idCapturados = UserDefaults.standard.array(forKey: "pokemons_capturados") as? [Int] ?? []
        totalCapturados = idCapturados.count
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Treinador")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.8), radius: 10)
                Text("Treinador Claudinei ")
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Divider()
                HStack(alignment: .top) {
                    VStack {
                        Text("Pokemons Capturados")
                            .font(.headline)
                            .padding(.bottom, 50)
                        Text("\(totalCapturados)/1302")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("Pokemon Favorito")
                            .font(.headline)
                        Text("?")
                    }
                    
                }
                .padding(.top, 20)
                .padding(.horizontal)
                Spacer()

            }
            .padding(.top, 50)
            .navigationTitle("Perfil")
        }
        .task {
            carregarCapturados()
        }
    }

}

//#Preview {
//    ExibirPerfil()
//}

