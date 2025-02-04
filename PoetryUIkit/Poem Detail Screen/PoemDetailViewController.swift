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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}


 
  
 


