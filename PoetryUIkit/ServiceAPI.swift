//
//  ServiceAPI.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 03/02/2025.
//

import Foundation
import Combine

struct AuthorsList: Codable {
    let authors: [String]
}

class ServiceAPI{
    
    @MainActor static let shared = ServiceAPI()
    
    //MARK: - PoetryDB
    
    func fetchAllPoemsPublisher() -> AnyPublisher<[Poem], Error> {
        guard let url = URL(string: "https://poetrydb.org/random/10") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Poem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func fetchAuthorsPublisher() -> AnyPublisher<AuthorsList, Error> {
        guard let url = URL(string: "https://poetrydb.org/authors") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: AuthorsList.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchPoemsForAuthor(author: String) -> AnyPublisher<[Poem],Error> {
        
        let encodedAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "https://poetrydb.org/author/\(encodedAuthor)") else {
           
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Poem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: - WIKIPEDIA
    
    func fetchAuthorSummary(author: String) -> AnyPublisher<WikiSummary,Error> {
        let encodedAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)") else {
           
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: WikiSummary.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        
    }
    
}
