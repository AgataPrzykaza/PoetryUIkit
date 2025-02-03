//
//  ViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 31/01/2025.
//

import UIKit

class PoemListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    let poems = [
        Poem(title: "Prologue to Mr Addison's Tragedy", author: "Alexander Pope", text: "To wake the soul by tender strokes of art, To raise the genius, and to mend the heart."),
        Poem(title: "Comus", author: "John Milton", text: "A Masque Presented At Ludlow Castle, 1634. The Lady enters, singing."),
        Poem(title: "On Napoleon's Escape From Elba", author: "George Gordon, Lord Byron", text: "ONCE fairly set out on his party of pleasure, the Warlord of France bent his steps to the North."),
        Poem(title: "Fragment From the 'Monk of Atropos'", author: "George Gordon, Lord Byron", text: "Beside the confines of the Ægean main, The land of Destiny, eternal Spain."),
        Poem(title: "To Autumn", author: "John Keats", text: "Season of mists and mellow fruitfulness, Close bosom-friend of the maturing sun."),
        Poem(title: "Ozymandias", author: "Percy Bysshe Shelley", text: "I met a traveler from an antique land who said: Two vast and trunkless legs of stone stand in the desert."),
        Poem(title: "Daffodils", author: "William Wordsworth", text: "I wandered lonely as a cloud that floats on high o'er vales and hills."),
        Poem(title: "The Tyger", author: "William Blake", text: "Tyger Tyger, burning bright, in the forests of the night."),
        Poem(title: "Sonnet 18", author: "William Shakespeare", text: "Shall I compare thee to a summer's day? Thou art more lovely and more temperate."),
        Poem(title: "If", author: "Rudyard Kipling", text: "If you can keep your head when all about you are losing theirs and blaming it on you.")
    ]


    //MARK: - View controller lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setupCollectionView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
            
        // Opcjonalnie ustaw, żeby ten widok zawsze korzystał z dużego tytułu
        navigationItem.largeTitleDisplayMode = .always
        
        
      
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


