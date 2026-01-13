//
//  RegisterView.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var registerModel = RegisterViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("background_login")
                .resizable()
                .ignoresSafeArea()
                .navigationBarHidden(true)
            VStack{
                header
                fullnameField
                usernameField
                passwordField
                confirmPasswordField
                actionButtons
            }
            .padding()
        }
        .alert("Thành công", isPresented: Binding(
            get: {
                if case .success = registerModel.state { return true }
                return false
            },
            set: { _ in
                registerModel.reset()
            }
        )) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Tài khoản của bạn đã được đăng ký thành công!")
        }
        
        .alert("Thất bại", isPresented: .constant(isError)) {
            Button("OK", role: .cancel) {
                registerModel.reset()
            }
        } message: {
            Text(errorMessage)
        }
    }
}

private extension RegisterView {
    var header: some View {
        Text("Đăng ký để sử dụng dịch vụ!")
            .font(.title)
            .bold()
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

private extension RegisterView {
    var fullnameField: some View {
        VStack(alignment: .leading) {
            Text("Họ và tên")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
            
            TextField(
                "",
                text: $registerModel.fullname,
                prompt: Text("Nhập họ và tên...")
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

private extension RegisterView {
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
                text: $registerModel.username,
                prompt: Text("Nhập tài khoản...")
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

private extension RegisterView {
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
                text: $registerModel.password,
                prompt: Text("Nhập mật khẩu...")
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

private extension RegisterView {
    var confirmPasswordField: some View {
        VStack(alignment: .leading) {
            Text("Nhập lại mật khẩu")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 30)
            
            SecureField(
                "",
                text: $registerModel.confirmPassword,
                prompt: Text("Nhập lại mật khẩu...")
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

private extension RegisterView {
    var actionButtons: some View {
        VStack (spacing: 20) {
            Button {
                registerModel.register()
            } label: {
                switch registerModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .tint(.white)
                default:
                    Text("Đăng ký")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                        .font(.title3)
                }
            }
            .disabled(registerModel.state == .loading)
            
            HStack{
                Text("Đã có tài khoản ?")
                    .foregroundStyle(.white)
                    .font(.body)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Đăng nhập ngay")
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

private extension RegisterView {
    var isError: Bool {
        if case .error = registerModel.state {
            return true
        }
        return false
    }
    
    var errorMessage: String {
        if case .error(let message) = registerModel.state {
            return message
        }
        return ""
    }
    
}

#Preview {
    RegisterView()
}
