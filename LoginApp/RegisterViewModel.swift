//
//  RegisterViewModel.swift
//  LoginApp
//
//  Created by Nhs@123456 on 12/1/26.
//

import Foundation
internal import Combine


class RegisterViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var loading = false
    @Published var error: String?
    
    func register(onSuccess: @escaping () -> Void) {
        loading = true
        error = nil
        
        guard let url = URL(string: "https://bin.h00k.dev/ff318635-e377-47d8-bb32-c81a6ee08052/register") else {
            loading = false
            error = "Lỗi API"
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
                self.loading = false
                
                if let err = err {
                    print("Error: ", err.localizedDescription)
                    self.error = "Register thất bại"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Thông tin không hợp lệ"
                    return
                }
                
                print("Status code: ", httpResponse.statusCode)
                
                guard (200...299) .contains(httpResponse.statusCode) else {
                    self.error = "Sai thông tin"
                    return
                }
                
                
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response body: ")
                        print(jsonString)
                    } else {
                        print("Không convert được data thành string")
                    }
                }
                
                onSuccess()
            }
        }.resume()
    }
}
