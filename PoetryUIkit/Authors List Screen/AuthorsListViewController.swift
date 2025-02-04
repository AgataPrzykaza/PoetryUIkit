//
//  AuthorsListViewController.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import UIKit
import Combine

class AuthorsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var tableView: UITableView!
    
    var authors: [String] = []
    var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 100
        // Do any additional setup after loading the view.
        
        ServiceAPI().fetchAuthorsPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Błąd pobierania authors: \(error)")
                    
                }
            } receiveValue: { [weak self] fetchAuthor in
                self?.authors = fetchAuthor.authors
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        authors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell", for: indexPath) as! AuthorsListTableViewCell
        
        let entry = authors[indexPath.row]
        
        cell.authorNameLabel.text = entry
        
        return cell
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "authorDetail" else{
            return
        }
        
        
        guard let detailVC = segue.destination as? AuthorViewController , let selectedAuthorCell = sender as? AuthorsListTableViewCell, let indexPath = tableView.indexPath(for: selectedAuthorCell ) else{
            fatalError("Could not get indexPath")
        }
        
        let selectedAuthor = authors[indexPath.row]
        detailVC.author = selectedAuthor
        
    }
    
    



}
