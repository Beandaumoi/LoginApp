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
                header
                usernameField
                passwordField
                actionButtons
            }
            .padding()
        }
        .onChange(of: viewModel.state) { oldValue, newValue in
            if case .success = newValue {
                onLoginSuccess()
            }
        }
        .alert(
            "Đăng nhập thất bại",
            isPresented: .constant(isError)
        ) {
            Button("OK", role: .cancel) {
                viewModel.reset()
            }
        } message: {
            Text(errorMessage)
        }
    }
}


private extension LoginView {
    var header: some View {
        Text("Chào mừng đến với trang đăng nhập!")
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

private extension LoginView {
    var usernameField: some View {
        VStack(alignment: .leading) {
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
        }
    }
}

private extension LoginView {
    var passwordField: some View {
        VStack(alignment: .leading) {
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
        }
    }
}

private extension LoginView {
    var actionButtons: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.login()
            } label: {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .tint(.white)
                default:
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
            .disabled(viewModel.state == .loading)
            
            HStack{
                Text("Chưa có tài khoản ?")
                    .foregroundStyle(.white)
                    .font(.body)
                Button {
                    onRegister()
                    viewModel.reset()
                } label: {
                    Text("Đăng ký ngay")
                        .bold()
                        .foregroundStyle(.red)
                        .cornerRadius(8)
                        .font(.body)
                }
                
            }
        }
        .padding(.top, 30)
    }
}


private extension LoginView {
    var isError: Bool {
        if case .error = viewModel.state {
            return true
        }
        return false
    }
    
    var errorMessage: String {
        if case .error(let message) = viewModel.state {
            return message
        }
        return ""
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
