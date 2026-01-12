//
//  ContentView.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var goToMain = false
    @State private var goToRegister = false
    
    var body: some View {
        NavigationStack {
            LoginView(onLoginSuccess: {
                goToMain = true
            }, onRegister: {
                goToRegister = true
            })
            .navigationDestination(isPresented: $goToMain, destination: {
                Main()
            })
            .navigationDestination(isPresented: $goToRegister, destination: {
                RegisterView()
            })
        }
    }
}

#Preview {
    ContentView()
}
