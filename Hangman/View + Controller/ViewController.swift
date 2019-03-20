//
//  ViewController.swift
//  Hangman
//
//  Created by Alexander Selivanov on 14/03/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let letterCellSize = CGSize(width: 50, height: 50)
    
    let rusLetters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
//    let engLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    // UI -------------
    private var failsLabel: UILabel!
    private var wordNumberLabel: UILabel!
    private var promptLabel: UILabel!
    private var lettersCollectionView: UICollectionView! {
        didSet {
            lettersCollectionView.dataSource = self
            lettersCollectionView.delegate = self
        }
    }
    // ----------------

    private let hangmanGame = Hangman()

    override func loadView() {

        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) // #colorLiteral(red: 0.1238629738, green: 0.2256446546, blue: 0, alpha: 1)

        createUI()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        hangmanGame.delegate = self
        hangmanGame.start()
    }

    private func createUI() {

        failsLabel = UILabel()
        failsLabel.translatesAutoresizingMaskIntoConstraints = false
        failsLabel.font = UIFont(name: "StrokeRUSBYLYAJKA-Medium", size: 17)
        failsLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        view.addSubview(failsLabel)

        wordNumberLabel = UILabel()
        wordNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        wordNumberLabel.font = UIFont(name: "StrokeRUSBYLYAJKA-Medium", size: 17)
        wordNumberLabel.textAlignment = .right
        wordNumberLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        view.addSubview(wordNumberLabel)

        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.font = UIFont(name: "StrokeRUSBYLYAJKA-Medium", size: 40)
        promptLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        promptLabel.textAlignment = .center
        promptLabel.adjustsFontSizeToFitWidth = true
        promptLabel.minimumScaleFactor = 0.25
        view.addSubview(promptLabel)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        lettersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        lettersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lettersCollectionView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        lettersCollectionView.layer.cornerRadius = 5
        lettersCollectionView.layer.borderWidth = 3
        lettersCollectionView.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        lettersCollectionView.layer.masksToBounds = true
        lettersCollectionView.register(LettersCollectionViewCell.self, forCellWithReuseIdentifier: "letterCell")
        view.addSubview(lettersCollectionView)

        NSLayoutConstraint.activate([

            failsLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            failsLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            wordNumberLabel.topAnchor.constraint(equalTo: failsLabel.topAnchor),
            wordNumberLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            wordNumberLabel.leadingAnchor.constraint(equalTo: failsLabel.trailingAnchor),

            promptLabel.topAnchor.constraint(lessThanOrEqualTo: wordNumberLabel.bottomAnchor, constant: 50),
            promptLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            promptLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            promptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            lettersCollectionView.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 50),
            lettersCollectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            lettersCollectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            lettersCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16)
        ])
    }

    private func updateUI() {

        failsLabel.text = "Ошибок: \(hangmanGame.fails) из \(hangmanGame.MAX_FAILS)"
        wordNumberLabel.text = "Слово: \(hangmanGame.currentWordNumber) из \(hangmanGame.WORD_COUNT)"
        promptLabel.text = hangmanGame.prompt
        
        lettersCollectionView.reloadData()
    }
}

extension ViewController: HangmanDelegate {

    func gameChanged() {
        updateUI()
    }

    func wordSolved(completion: (() -> ())?) {

        gameChanged()

        let alert = UIAlertController(title: "Ура!", message: "Слово разгадано!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Следующее", style: .default) { []_ in
            completion?()
        }

        alert.addAction(action)
        present(alert, animated: true)
    }

    func gameOver(reason: HangmanGameOverReasons) {

        gameChanged()
        
        var message = ""

        switch reason {
        case .win:
            message = "Победа!!!"
        case .fail:
            message = "Тебя повесили.\n Разгадано слов: \(hangmanGame.currentWordNumber - 1) из \(hangmanGame.WORD_COUNT)"
        }

        let alert = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Повторить", style: .default) { [weak self] (action) in
            self?.hangmanGame.start()
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rusLetters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCell", for: indexPath) as! LettersCollectionViewCell
        let letter = String(rusLetters[rusLetters.index(rusLetters.startIndex, offsetBy: indexPath.item)])

        cell.letterLabel.text = letter
        cell.letterLabel.textColor = hangmanGame.activatedLetters.contains(letter) ? #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1) : #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cell.isUserInteractionEnabled = !hangmanGame.activatedLetters.contains(letter)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let letter = String(rusLetters[rusLetters.index(rusLetters.startIndex, offsetBy: indexPath.item)])
        
        hangmanGame.selectLetter(letter)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return letterCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
