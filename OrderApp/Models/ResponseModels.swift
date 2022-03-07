//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct CategoriesResponse: Codable {
    let categories: [String]
}


struct OrderResponse: Codable {
    let prepTime: Int
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}

struct Categories: Codable {
    let categories: [String]
} // end struct Categories

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodeingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    } // end enum

} // end struct PreparationTime
