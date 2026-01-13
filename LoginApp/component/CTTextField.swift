//
//  CTTextField.swift
//  LoginApp
//
//  Created by Nhs@123456 on 13/1/26.
//

import SwiftUI

struct CTTextField: View {
    let title: String
    let placeHolder: String
    @Binding var text: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeHolder)
                        .foregroundStyle(.white.opacity(0.8))
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 2)
                )
                .foregroundStyle(.white)
            }
        }
    }
}

