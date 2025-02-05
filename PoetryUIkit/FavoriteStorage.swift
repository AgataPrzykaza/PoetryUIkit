//
//  FavoriteStorage.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 05/02/2025.
//
import Foundation

class FavoriteStorage {
    
    @MainActor static let shared = FavoriteStorage()
    
    let favoriteIDsKey = "favoriteIDs"

    //MARK : - UserDefaults
    
    // Funkcja, która zwraca aktualną listę ulubionych identyfikatorów
    func getFavoriteIDs() -> [String] {
        let favorites = UserDefaults.standard.array(forKey: favoriteIDsKey) as? [String] ?? []
        return favorites
    }

    // Funkcja dodająca nowy identyfikator do ulubionych
    func addFavoriteID(_ id: String) {
        var favorites = getFavoriteIDs()
        if !favorites.contains(id) {
            favorites.append(id)
            UserDefaults.standard.set(favorites, forKey: favoriteIDsKey)
        }
    }

    // Funkcja usuwająca identyfikator z ulubionych
    func removeFavoriteID(_ id: String) {
        var favorites = getFavoriteIDs()
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: favoriteIDsKey)
        }
    }

    // Funkcja sprawdzająca, czy dany identyfikator znajduje się w ulubionych
    func isFavorite(_ id: String) -> Bool {
        return getFavoriteIDs().contains(id)
    }
    
    
}
