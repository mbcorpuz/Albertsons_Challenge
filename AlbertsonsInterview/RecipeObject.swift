//
//  RecipeObject.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 1/31/21.
//

import Foundation

struct Result: Codable {
    let title: String
    let href: String
    let ingredients: String
    let thumbnail: String
}

struct Recipe: Codable {
    let title: String
    let version: Double
    let href: String
    let results: [Result]
}
