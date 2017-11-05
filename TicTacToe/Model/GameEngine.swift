//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Chingoo on 10/22/17.
//  Copyright © 2017 Chingoo. All rights reserved.
//

import Foundation


class GameEngine: NSObject {
    
    enum State {
        case Empty
        case PlayerOne
        case PlayerTwo
    }
    
    var gameState = [[State]]()
    let gameSize: Int
    
    let winnerOne = "Winner: Player One"
    let WinnerTwo = "Winner: Player Two"
    
    init(gameSize: Int) {
        self.gameSize = gameSize
    }
    
    func resetGameState() {
        gameState.removeAll()
        for _ in 0 ..< gameSize {
            let row = Array(repeating: State.Empty, count: self.gameSize)
            gameState.append(row)
        }
    }
    
    func checkForWinner() -> String? {
        var winnerName: String?
        
        if let winner = checkRowsForWinner() {
            if winner == .PlayerOne {
                winnerName = winnerOne
            } else {
                winnerName = WinnerTwo
            }
        }
        
        if let winner = checkColumnForWinner() {
            if winner == .PlayerOne {
                winnerName = winnerOne
            } else {
                winnerName = WinnerTwo
            }
        }
        
        if let winner = checkDiagonalWinner() {
            if winner == .PlayerOne {
                winnerName = winnerOne
            } else {
                winnerName = WinnerTwo
            }
        }
        
        return winnerName
    }
    
    
    func checkWinnerArray(arr: [State]) -> State? {
        let winnerArray = Array(Set(arr))
        if winnerArray.count == 1 {
            if winnerArray.first != .Empty {
                return winnerArray.first
            }
        }
        return nil
    }
    
    
    func checkRowsForWinner() -> State? {
        for row in 0 ..< gameSize {
            var rowStates = [State]()
            for column in 0 ..< gameSize {
                rowStates.append(gameState[row][column])
            }
            guard let winner = checkWinnerArray(arr: rowStates) else { continue }
            return winner
        }
        return nil
    }
    
    
    func checkColumnForWinner() -> State? {
        for column in 0 ..< gameSize {
            var columnSates = [State]()
            for row in 0 ..< gameSize {
                columnSates.append(gameState[row][column])
            }
            guard let columnWinner = checkWinnerArray(arr: columnSates) else { continue }
            return columnWinner
        }
        return nil
    }
    
    func checkDiagonalWinner() -> State? {
        var leftDiagonalWinner = [State]()
        var rightDiagonalWinner = [State]()
        for row in 0 ..< gameSize {
            for column in 0 ..< gameSize {
                if row == column {
                    leftDiagonalWinner.append(gameState[row][column])
                }
                if row + column == (gameSize - 1) {
                    rightDiagonalWinner.append(gameState[row][column])
                }
            }
        }
        if let ldw = checkWinnerArray(arr: leftDiagonalWinner) {
            return ldw
        }
        if let rdw = checkWinnerArray(arr: rightDiagonalWinner) {
            return rdw
        }
        
        return nil
    }
    
    func setPlayerMarkOn(position: (Int, Int), forPlayer: State) {
        gameState[position.0][position.1] = forPlayer
    }
    
    func convertStringToTupleFrom(title: String) -> (Int, Int) {
        let numbers = title.components(separatedBy: ",")
        let tuple = (Int(numbers[0])!, Int(numbers[1])!)
        return tuple
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

