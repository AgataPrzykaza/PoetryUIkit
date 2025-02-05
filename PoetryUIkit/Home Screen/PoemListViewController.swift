//
//  ViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 31/01/2025.
//

import UIKit
import Combine

class PoemListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var poems: [Poem] = []
    var cancellables = Set<AnyCancellable>()

    //MARK: - View controller lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setupCollectionView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
        
        ServiceAPI.shared.fetchAllPoemsPublisher()
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
        
      
    }
   
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
   
      
    
    //MARK: - UICOllectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        poems.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let poemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "poemCell", for: indexPath) as! PoemCell
       
        
       
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "poemDetail" else{
            return
        }
        
        guard let poemDetailsViewController = segue.destination as? PoemDetailViewController, let selectedPoemCell = sender as? PoemCell, let indexPath = collectionView.indexPath(for: selectedPoemCell) else{
            fatalError("Could not get indexPath")
        }
        
        
        
        let selectedPoem: Poem
        
        selectedPoem = poems[indexPath.row]
        
        poemDetailsViewController.poem = selectedPoem
    }
    
    
}


