//
//  PoemDetailViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 03/02/2025.
//

import UIKit


class PoemDetailViewController: UIViewController {

    @IBOutlet var poemTitleLabel: UILabel!
    @IBOutlet var poemAuthorLabel: UILabel!
    @IBOutlet var poemBodyTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var poem : Poem?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarFavoriteButton()

        poemTitleLabel.text = poem?.title
        poemAuthorLabel.text = poem?.author
        poemBodyTextView.text = poem?.text
        
        // Do any additional setup after loading the view.
        
        // Jeśli masz już scrollView
           scrollView.showsVerticalScrollIndicator = false
           scrollView.showsHorizontalScrollIndicator = false
        
        navigationController?.navigationBar.prefersLargeTitles = false
            
            // Opcjonalnie ustaw, żeby ten widok zawsze korzystał z dużego tytułu
        navigationItem.largeTitleDisplayMode = .inline
        
        navigationItem.title = poem?.title
    }
    

    //MARK: - Update Favorite
    
    // Dodaj przycisk w nawigacji, który będzie przełączał stan ulubionego
        private func setupNavigationBarFavoriteButton() {
            let favoriteImageName = FavoriteStorage.shared.isFavorite(poem!.id) ? "heart.fill" : "heart"
            let favoriteImage = UIImage(systemName: favoriteImageName)
            let favoriteButton = UIBarButtonItem(image: favoriteImage,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(favoriteTapped))
            navigationItem.rightBarButtonItem = favoriteButton
        }
        
        @objc private func favoriteTapped() {
            if FavoriteStorage.shared.isFavorite(poem!.id) {
                FavoriteStorage.shared.removeFavoriteID(poem!.id)
            } else {
                FavoriteStorage.shared.addFavoriteID(poem!.id)
            }
            // Aktualizuj przycisk po zmianie stanu
            setupNavigationBarFavoriteButton()
        }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}


 
  
 


