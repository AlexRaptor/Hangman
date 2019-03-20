//
//  LettersCollectionViewCell.swift
//  Hangman
//
//  Created by Alexander on 20/03/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class LettersCollectionViewCell: UICollectionViewCell {
    
    var letterLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        letterLabel = UILabel()
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.font = UIFont.systemFont(ofSize: 36)
        letterLabel.textAlignment = .center
        
        self.addSubview(letterLabel)
        
        NSLayoutConstraint.activate([
            
            letterLabel.topAnchor.constraint(equalTo: self.topAnchor),
            letterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
