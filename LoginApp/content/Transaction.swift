//
//  Transaction.swift
//  LoginApp
//
//  Created by Nhs@123456 on 13/1/26.
//

import Foundation

struct Transaction: Identifiable, Decodable {
    let id: String
    let date: String
    let amount: Double
    let currency: String
    let method: String
    let status: String
    let description: String
    let reference: String
}
