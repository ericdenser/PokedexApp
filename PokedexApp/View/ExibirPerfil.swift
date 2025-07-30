//
//  ExibirPerfil.swift
//  APPPOKEDEX
//
//  Created by Aluno Mack on 30/07/25.
//

import SwiftUI

struct ExibirPerfil: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Seu Perfil")
                    .font(.largeTitle)
                    .padding()

                Text("Personalização virá em breve!")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Perfil")
        }
    }
}

