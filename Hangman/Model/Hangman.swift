//
//  Hangman.swift
//  Hangman
//
//  Created by Alexander Selivanov on 14/03/2019.
//  Copyright © 2019 Alexander Selivanov. All rights reserved.
//

import Foundation

protocol HangmanDelegate {

    func gameChanged()
    func wordSolved(completion: (() -> ())?)
    func gameOver(reason: HangmanGameOverReasons)
}

enum HangmanGameOverReasons: Int {
    case win
    case fail
}

class Hangman {

    let NULL_CHAR = "."

    var delegate: HangmanDelegate?

    let MAX_FAILS = 7
    lazy var WORD_COUNT = { self.words.count }()

    private( set ) var currentWordNumber = 0
    private( set ) var fails = 0
    private var words = [String]()
    private( set ) var activatedLetters = [String]()
    private( set ) var prompt = ""

    func selectLetter(_ letter: String) {

        activatedLetters.append(letter)

        if !words[currentWordNumber - 1].contains(letter) {

            fails += 1

            if fails == MAX_FAILS {

                delegate?.gameOver(reason: .fail)
                return
            }
        } else {

            let currentWord = words[currentWordNumber - 1].uppercased()
            prompt = ""

            for letter in currentWord {

                prompt += activatedLetters.contains(String(letter)) ? String(letter) : NULL_CHAR
            }
        }

        if prompt.contains(NULL_CHAR) {
            delegate?.gameChanged()
        } else {
            if currentWordNumber == WORD_COUNT {
                delegate?.gameOver(reason: .win)
            } else {
                delegate?.wordSolved() { [weak self] in
                    self?.nextWord()
                }
            }
        }
    }

    init() {
        loadWords()
    }

    func start() {

        words.shuffle()
        currentWordNumber = 0
        nextWord()
    }

    private func nextWord() {

        activatedLetters.removeAll()
        currentWordNumber += 1

        if currentWordNumber > WORD_COUNT {
            delegate?.gameOver(reason: .win)
            return
        }

        fails = 0
        prompt = String(repeating: NULL_CHAR, count: words[currentWordNumber - 1].count)
        delegate?.gameChanged()
    }

    private func loadWords() {

        if let wordFileURL = Bundle.main.url(forResource: "words", withExtension: "txt"),
           let  wordFileContents = try? String(contentsOf: wordFileURL) {

            words = wordFileContents.components(separatedBy: "\n").compactMap { $0.uppercased() }.filter { !$0.isEmpty }
        }
    }
}
