//
//  ViewController.swift
//  TicTacToe
//
//  Created by Chingoo on 10/22/17.
//  Copyright © 2017 Chingoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gameSize = Int()
    
    var isPlayerOne = true
    
    lazy var game = GameEngine(gameSize: gameSize)
    
    let resetGameTitleName = "Player1: Red  |  Player2: Blue"
    
    let gameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resetButtonName = "Reset Game"
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view.addSubview(selectionView)
    }
    
    lazy var selectionView: InitialSelectionView = {
        let selectView = Bundle.main.loadNibNamed("IntialSelectView", owner: self, options: nil)!.first as! InitialSelectionView
        selectView.center = self.view.center
        selectView.threeButton.addTarget(self, action: #selector(self.threeTapped), for: .touchUpInside)
        selectView.fourButton.addTarget(self, action: #selector(self.fourTapped), for: .touchUpInside)
        selectView.fiveButton.addTarget(self, action: #selector(self.fiveTapped), for: .touchUpInside)
        return selectView
    }()
    
    @objc private func threeTapped() {
        self.selectionView.removeFromSuperview()
        gameSize = 3
        setupGameBoard(gameSize: 3)
    }
    
    @objc private func fourTapped() {
        self.selectionView.removeFromSuperview()
        gameSize = 4
        setupGameBoard(gameSize: 4)
    }
    
    @objc private func fiveTapped() {
        self.selectionView.removeFromSuperview()
        gameSize = 5
        setupGameBoard(gameSize: 5)
        containerView.updateConstraints()
    }
    
    func setupGameBoard(gameSize: Int) {
        setupGameTitleLabel()
        setupContainerView(gameSize: gameSize)
        
        setupResetButton()
        game.resetGameState()
        for row in 0 ..< gameSize {
            for column in 0 ..< gameSize {
                constructButtonAt(row: row, column: column)
            }
        }
    }
    
    
    func setupContainerView(gameSize: Int) {
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 100).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
    }
    
    func setupGameTitleLabel() {
        view.addSubview(gameTitleLabel)
        gameTitleLabel.text = resetGameTitleName
        gameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        gameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupResetButton() {
        view.addSubview(resetButton)
        resetButton.setTitle(resetButtonName, for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = .darkGray
        resetButton.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        
        resetButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func resetAllButtons(shouldResetButtonColor resetColor: Bool, shouldEnableButton: Bool) {
        for v in containerView.subviews {
            guard let button = v as? UIButton, let title = button.currentTitle else { continue }
            if title != resetButtonName {
                button.removeFromSuperview()
                if resetColor {
                    button.backgroundColor = .blue
                }
                button.isEnabled = shouldEnableButton
            }
        }
        
    }
    
    func constructButtonAt(row: Int, column: Int) {
        let multipler = gameSize * 10
        let xValue = (column * (120 - multipler))
        let yValue = (row * (120 - multipler))
        let frame = CGRect(x: xValue, y: yValue, width: 110 - multipler, height: 110 - multipler)
        let button = UIButton(frame: frame)
        button.backgroundColor = .black
        
        let title = "\(row),\(column)"
        button.setTitle(title, for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        containerView.addSubview(button)
    }
    
    @objc func handleResetButton(resetButton: UIButton) {
        isPlayerOne = true
        resetAllButtons(shouldResetButtonColor: true, shouldEnableButton: true)
        containerView.removeFromSuperview()
        game.resetGameState()
        gameTitleLabel.text = resetGameTitleName
        self.view.addSubview(selectionView)
        
    }
    
    @objc func handleButtonTapped(button: UIButton) {
        button.isEnabled = false
        guard let title = button.currentTitle else { return }
        let indexValue = game.convertStringToTupleFrom(title: title)
        if isPlayerOne {
            game.setPlayerMarkOn(position: indexValue, forPlayer: .PlayerOne)
            button.backgroundColor = .red
            isPlayerOne = false
        } else {
            game.setPlayerMarkOn(position: indexValue, forPlayer: .PlayerTwo)
            button.backgroundColor = .blue
            isPlayerOne = true
        }
    
        if let playerName = game.checkForWinner() {
            gameTitleLabel.text = playerName
            resetAllButtons(shouldResetButtonColor: false, shouldEnableButton: false)
        }
    }
}

