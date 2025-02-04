//
//  WikiSummary.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import Foundation

struct WikiSummary: Codable {
    let title: String
    let extract: String
    let thumbnail: Thumbnail?
    
    struct Thumbnail: Codable {
        let source: String
        let width: Int
        let height: Int
    }
}
