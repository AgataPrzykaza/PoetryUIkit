//
//  CollectionHeaderView.swift
//  PoetryUIkit
//
//  Created by Agata Przykaza on 04/02/2025.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CollectionHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Etykieta z opisem autora (kilka zdań)
    let authorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0  // Pozwala na wyświetlenie wielu linii
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
        addSubview(titleLabel)
        addSubview(authorDescriptionLabel)
        
        // Ustaw constraints dla titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            
            // Etykieta opisu autora obok obrazka
            authorDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:8),
            authorDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authorDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            authorDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)

        ])
    }
}
