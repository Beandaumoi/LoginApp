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
    
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var fullname = ""
    
    var body: some View {
        ZStack {
            Image("background_login")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text("Đăng ký để sử dụng dịch vụ!!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
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
                
                VStack (spacing: 20) {
                    Button {
                        guard registerModel.password == registerModel.confirmPassword else {
                            errorMessage = "Mật khẩu và xác nhận mật khẩu không khớp!"
                            showErrorAlert = true
                            return
                        }
                        
                        registerModel.register(onSuccess: {
                            showSuccessAlert = true
                        })
                    } label: {
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
                .padding(.top, 30)
            }
            .padding()
        }
        .alert("Đăng ký thành công", isPresented: $showSuccessAlert) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Tài khoản của bạn đã được tạo thành công!")
        }
        
        .alert("Lỗi đăng ký", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    RegisterView()
}
