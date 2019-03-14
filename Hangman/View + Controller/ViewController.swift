//
//  ViewController.swift
//  Hangman
//
//  Created by Alexander Selivanov on 14/03/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rusLetters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"

    // UI -------------
    private var failsLabel: UILabel!
    private var wordNumberLabel: UILabel!
    private var promptLabel: UILabel!
    private var letterButtons = [UIButton]()
    // ----------------

    private let hangmanGame = Hangman()

    override func loadView() {

        view = UIView()
        view.backgroundColor = .white

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
        view.addSubview(failsLabel)

        wordNumberLabel = UILabel()
        wordNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        wordNumberLabel.textAlignment = .right
        view.addSubview(wordNumberLabel)

        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.font = UIFont.systemFont(ofSize: 40)
        promptLabel.textAlignment = .center
        promptLabel.adjustsFontSizeToFitWidth = true
        promptLabel.minimumScaleFactor = 0.25
        view.addSubview(promptLabel)

        let letterButtonsContainerView = UIView()
        letterButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        letterButtonsContainerView.layer.borderWidth = 1
        letterButtonsContainerView.layer.cornerRadius = 5
        letterButtonsContainerView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        letterButtonsContainerView.layer.masksToBounds = true
        view.addSubview(letterButtonsContainerView)

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

            letterButtonsContainerView.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 50),
            letterButtonsContainerView.widthAnchor.constraint(equalToConstant: 300),
            letterButtonsContainerView.heightAnchor.constraint(equalToConstant: 300),
            letterButtonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let letterButtonWidth = 50
        let letterButtonHeight = 50

        for (index, letter) in rusLetters.enumerated() {

            let column = index % 6
            let row = index / 6

            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            letterButton.setTitle(String(letter), for: .normal)
            letterButton.frame = CGRect(x: letterButtonWidth * column, y: letterButtonHeight * row, width: letterButtonWidth, height: letterButtonHeight)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

            letterButtons.append(letterButton)
            letterButtonsContainerView.addSubview(letterButton)
        }
    }

    private func updateUI() {

        failsLabel.text = "Ошибок: \(hangmanGame.fails) из \(hangmanGame.MAX_FAILS)"
        wordNumberLabel.text = "Слово: \(hangmanGame.currentWordNumber) из \(hangmanGame.WORD_COUNT)"
        promptLabel.text = hangmanGame.prompt

        for letterButton in letterButtons {

            if let letter = letterButton.titleLabel?.text, hangmanGame.activatedLetters.contains(letter) {
                letterButton.isEnabled = false
            } else {
                letterButton.isEnabled = true
            }
        }
    }

    @objc func letterTapped(_ sender: UIButton) {

        guard let letter = sender.titleLabel?.text else { return }

        hangmanGame.selectLetter(letter)
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
