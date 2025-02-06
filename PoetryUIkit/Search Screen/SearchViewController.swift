//
//  SearchViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 06/02/2025.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate  {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var collectionView: UICollectionView!

    var searchResult: [Poem] = []
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        searchTextField.delegate = self

        collectionView.dataSource = self
        collectionView.delegate = self
        
       

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    //MARK: - TextField
    
   
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
            guard let query = textField.text, !query.isEmpty else {
                return false
            }

       
            fetchSearch(searchText: query)

           
            textField.resignFirstResponder()
            return true
        }
    
    //MARK: - COllection
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let poemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "poemSearchCell", for: indexPath) as! PoemCell
       
        
       
        let poem = searchResult[indexPath.row]
        
        
      
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
    func fetchSearch(searchText: String){
        
        ServiceAPI.shared.fetchPoemSearch(title: searchText)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Błąd pobierania poem: \(error)")
                    
                }
            } receiveValue: { [weak self] fetchedPoems in
                self?.searchResult = fetchedPoems
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
            
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "searchDetail" else{
            return
        }
        
        guard let poemDetailsViewController = segue.destination as? PoemDetailViewController, let selectedPoemCell = sender as? PoemCell, let indexPath = collectionView.indexPath(for: selectedPoemCell) else{
            fatalError("Could not get indexPath")
        }
        
        
        
        let selectedPoem: Poem
        
        selectedPoem = searchResult[indexPath.row]
        
        poemDetailsViewController.poem = selectedPoem
        
    }
    

}
