//
//  LoginView.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    let onLoginSuccess: () -> Void
    let onRegister: () -> Void
    
    var body: some View {
        ZStack {
            Image("background_login")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text("Chào mừng đến với trang đăng nhập!!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Text("Tên đăng nhập")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                
                TextField(
                    "",
                    text: $viewModel.username,
                    prompt: Text("Nhập tài khoản...")
                        .foregroundStyle(.white.opacity(0.8))
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 2)
                )
                
                Text("Mật khẩu")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                
                SecureField(
                    "",
                    text: $viewModel.password,
                    prompt: Text("Nhập mật khẩu...")
                        .foregroundStyle(.white.opacity(0.8))
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 2)
                )
                
                VStack (spacing: 20) {
                    Button {
                        viewModel.login(onSuccess: {
                            onLoginSuccess()
                        })
                    } label: {
                        if viewModel.loading {
                            ProgressView()
                        } else {
                            Text("Đăng nhập")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.green)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                                .font(.title3)
                        }
                    }
                    
                    Button {
                        onRegister()
                    } label: {
                            Text("Đăng ký")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.red)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                                .font(.title3)
                    }
                }
                .padding(.top, 30)
            }
            .padding()
        }
        .alert("Đăng nhập thất bại", isPresented: .constant(viewModel.error != nil)) {
            Button("OK", role: .cancel) {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error ?? "")
        }
    }
}

#Preview {
    LoginView(
        onLoginSuccess: {
            print("Login Success")
        },
        onRegister: {
            print("Register Success")
        }
    )
}
