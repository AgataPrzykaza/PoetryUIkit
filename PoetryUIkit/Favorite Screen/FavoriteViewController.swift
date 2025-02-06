//
//  FavoriteViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 06/02/2025.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate  {
    
    @IBOutlet var collectionView: UICollectionView!

    var favoritePoems: [Poem] = []
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
        collectionView.reloadData()
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - COllection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritePoems.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let poemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePoemCell", for: indexPath) as! PoemCell
       
        
       
        let poem = favoritePoems[indexPath.row]
        
        
      
        poemCell.title.text = poem.title
        poemCell.author.text = poem.author
        poemCell.text.text = poem.text
        
        return poemCell
        
        
    }
    
    func setupCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = flowLayout
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let numberOfColumns: CGFloat
        
        if (traitCollection.horizontalSizeClass == .compact){
            numberOfColumns = 1
        }
        else{
            numberOfColumns = 2
        }
        
        let viewWidth = collectionView.frame.width
        let inset = 10.0
        let contentWidth = viewWidth - inset * (numberOfColumns + 1)
        let cellWidth = contentWidth / numberOfColumns
        let cellHeight = 150.0
        
        return CGSize(width: cellWidth, height: cellHeight)
        

    }
    
    
    
    //MARK: - Methods
    

    func getFavorites() {
        
        favoritePoems.removeAll()
        
        
        let dispatchGroup = DispatchGroup()
        
       
        if let savedPoems = UserDefaults.standard.array(forKey: FavoriteStorage.shared.favoriteIDsKey) as? [String] {
            for poemInfo in savedPoems {
                let components = poemInfo.split(separator: "|")
                if components.count == 2 {
                    let title = String(components[0])
                    let author = String(components[1])
                    
                   
                    dispatchGroup.enter()
                    
                   
                    ServiceAPI.shared.fetchPoemFromTitleAuthor(author: author, title: title)
                        .sink { completion in
                           
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print("Błąd pobierania poem: \(error)")
                            }
                            dispatchGroup.leave()
                        } receiveValue: { [weak self] fetchedPoems in
                            
                            if let poem = fetchedPoems.first {
                                self?.favoritePoems.append(poem)
                            }
                        }
                        .store(in: &cancellables)
                }
            }
            
           
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "favoritePoemDetail" else{
            return
        }
        
        guard let poemDetailsViewController = segue.destination as? PoemDetailViewController, let selectedPoemCell = sender as? PoemCell, let indexPath = collectionView.indexPath(for: selectedPoemCell) else{
            fatalError("Could not get indexPath")
        }
        
        
        
        let selectedPoem: Poem
        
        selectedPoem = favoritePoems[indexPath.row]
        
        poemDetailsViewController.poem = selectedPoem
    }
    

}
