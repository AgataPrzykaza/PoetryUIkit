//
//  AuthorViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import UIKit
import Combine

class AuthorViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var author: String = ""
    
    var poems: [Poem] = []
    var wikiSummary: WikiSummary?
    var cancellables = Set<AnyCancellable>()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupCollectionView()
        
            collectionView.dataSource = self
            collectionView.delegate = self
            
            // Rejestracja nagłówka
            collectionView.register(CollectionHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
            
            // Konfiguracja layoutu
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 175)
            }

        serviceAPI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
   
    
    //MARK: - Collection methods
   
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as! CollectionHeaderView
            
            header.titleLabel.text = author
            header.authorDescriptionLabel.text = wikiSummary?.extract
            return header
        }
        
       
        return UICollectionReusableView()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        poems.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let poemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "poemAuthorCell", for: indexPath) as! PoemCell
       
        
       
        let poem = poems[indexPath.row]
        
        
      
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
    
    private func serviceAPI(){
        
        ServiceAPI().fetchPoemsForAuthor(author: author)
                  .sink { completion in
                      switch completion {
                      case .finished:
                          break
                      case .failure(let error):
                          print("Błąd pobierania poem: \(error)")
                          
                      }
                  } receiveValue: { [weak self] fetchedPoems in
                      self?.poems = fetchedPoems
                      self?.collectionView.reloadData()
                  }
                  .store(in: &cancellables)
        
        ServiceAPI().fetchAuthorSummary(author: author)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Błąd pobierania wiki: \(error)")
                }
            } receiveValue: { [weak self] fetchedWiki in
                self?.wikiSummary = fetchedWiki
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables
            )
        
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
