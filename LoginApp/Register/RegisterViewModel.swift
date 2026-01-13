//
//  RegisterViewModel.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import Foundation
internal import Combine

enum RegisterState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

class RegisterViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published private(set) var state: RegisterState = .idle
    
    func register() {
        
        guard !fullname.isEmpty, !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            state = .error("Vui lòng nhập đầy đủ thông tin")
            return
        }
        
        guard password == confirmPassword else {
            state = .error("Xác nhận mật khẩu không đúng, vui lòng kiểm tra lại")
            return
        }
        
        state = .loading
        
        guard let url = URL(string: "https://bin.h00k.dev/ff318635-e377-47d8-bb32-c81a6ee08052/register") else {
            state = .error("Lỗi API")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "fullname": fullname,
            "username": username,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            DispatchQueue.main.async {
                if let err = err {
                    print("Error: ", err.localizedDescription)
                    self.state = .error("Register thất bại")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.state = .error("Thông tin không hợp lệ")
                    return
                }
                
                print("Status code: ", httpResponse.statusCode)
                
                guard (200...299) .contains(httpResponse.statusCode) else {
                    self.state = .error("Sai thông tin")
                    return
                }
                
                
                if let data = data,
                     let jsonString = String(data: data, encoding: .utf8){
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
        fullname = ""
        password = ""
        confirmPassword = ""
    }
}
