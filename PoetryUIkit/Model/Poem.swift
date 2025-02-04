//
//  Poem.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import Foundation

class Poem: Codable{
    
    let title : String
    let author : String
    let lines: [String]
    let linecount: String
    var text: String {
           return lines.joined(separator: "\n")
       }
    var id: String {title + "|" + author}
    
    init(title: String, author: String, lines: [String],linecount: String) {
        self.title = title
        self.author = author
        self.lines = lines
        self.linecount = linecount
    }
}
