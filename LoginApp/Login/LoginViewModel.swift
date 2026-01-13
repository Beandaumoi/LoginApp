//
//  LoginViewModel.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import Foundation
internal import Combine

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}


class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    
    @Published private(set) var state: LoginState = .idle
    
    func login() {
        
        guard !username.isEmpty, !password.isEmpty else {
            state = .error("Vui lòng nhập đầy đủ tài khoản và mật khẩu")
            return
        }
        
        state = .loading
        
        guard let url = URL(string: "https://bin.h00k.dev/ff318635-e377-47d8-bb32-c81a6ee08052/login") else {
            state = .error("Lỗi API")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "username": username,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            DispatchQueue.main.async {
                
                if let err = err {
                    print("Error: ", err.localizedDescription)
                    self.state = .error("Login thất bại")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.state = .error("Tài khoản hoặc mật khẩu không hợp lệ")
                    return
                }
                
                print("Status code: ", httpResponse.statusCode)
                
                guard (200...299) .contains(httpResponse.statusCode) else {
                    self.state = .error("Sai tài khoản hoặc mật khẩu")
                    return
                }
                
                
                if let data = data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("Response body: ")
                    print(jsonString)
                }
                
                self.state = .success
            }
        }.resume()
    }
    func reset() {
        state = .idle
        
        username = ""
        password = ""
    }
}
