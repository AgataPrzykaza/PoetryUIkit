//
//  CollectionHeaderView.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import UIKit

//MARK: - UIImage extension
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//MARK: - CollectionHeader

class CollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CollectionHeaderView"
    
    
    let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let authorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(circularImageView)
        addSubview(titleLabel)
        addSubview(authorDescriptionLabel)
        
        // Ustaw constraints dla titleLabel
        NSLayoutConstraint.activate([
            // Constraints dla circularImageView (po prawej stronie)
            circularImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            circularImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            circularImageView.widthAnchor.constraint(equalToConstant: 80),
            circularImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Constraints dla titleLabel - wyrównany pionowo z obrazkiem i zajmuje przestrzeń od lewej do obrazka
            titleLabel.centerYAnchor.constraint(equalTo: circularImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: circularImageView.leadingAnchor, constant: -8),
            
            // Constraints dla authorDescriptionLabel
            authorDescriptionLabel.topAnchor.constraint(equalTo: circularImageView.bottomAnchor, constant: 8),
            authorDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authorDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            authorDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
            
        ])
    }
    
    // Metoda konfiguracyjna do ustawiania danych nagłówka
        func configure(with title: String, authorDescription: String, imageUrl: String) {
            titleLabel.text = title
            authorDescriptionLabel.text = authorDescription
            circularImageView.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
        }
        
        // Ustawienie cornerRadius, aby obrazek był okrągły
        override func layoutSubviews() {
            super.layoutSubviews()
            circularImageView.layer.cornerRadius = circularImageView.frame.width / 2
        }
}
