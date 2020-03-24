//
//  GameManager.swift
//  LongSnake
//
//  Created by Ashis Laha on 23/03/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import SpriteKit

typealias Position = (row: Int, col: Int)
typealias Direction = (Int, Int)

struct PlayerDirection {
	static let left: Direction = (0, -1)
	static let right: Direction = (0, 1)
	static let up: Direction = (-1, 0)
	static let down: Direction = (1, 0)
}

struct GameStructure {
	static let rows: Int = 38
	static let cols: Int = 20
}

class GameManager {
	
	weak var scene: GameScene!
	private let nextIterationInterval: Double = 0.5
	private var nextIteration: Double!
	private var currentDirection = PlayerDirection.down
	
	init(scene: GameScene) {
		self.scene = scene
	}
	
	// MARK: start game
	public func startGame() {
		// starting players position
		scene.playerPositions.append((10,10))
		scene.playerPositions.append((10,11))
		scene.playerPositions.append((10,12))
		renderChange()
	}
	
	func renderChange() {
		
		// TODO:- can optimise here using hash-table
		for each in scene.gameArray {
			if contains(a: scene.playerPositions, b: (each.row, each.col)) {
				each.node.fillColor = .cyan
			} else {
				each.node.fillColor = .clear
			}
		}
	}
	
	private func contains(a: [(Int, Int)], b: (Int, Int)) -> Bool {
		for (row, col) in a {
			if row == b.0 && col == b.1 {
				return true
			}
		}
		return false
	}
	
	func update(time: Double) {
		guard nextIteration != nil else {
			nextIteration = time + nextIterationInterval
			return
		}
		
		if time >= nextIteration {
			nextIteration = time + nextIterationInterval
			updatePlayerPosition(direction: currentDirection)
		}
	}
	
	private func updatePlayerPosition(direction: Direction) {
		guard !scene.playerPositions.isEmpty else { return }
		
		// copy ith item into (i+1)th item from 0...(n-1)
		for i in stride(from: scene.playerPositions.count-1, to: 0, by: -1) {
			scene.playerPositions[i] = scene.playerPositions[i-1]
		}
		// update the first item
		scene.playerPositions[0] = (scene.playerPositions[0].row + direction.0, scene.playerPositions[0].col + direction.1)
		
		// update position if it crosses boundary
		let row = scene.playerPositions[0].row
		let col = scene.playerPositions[0].col
		
		if row > GameStructure.rows {
			scene.playerPositions[0].row = 0
		} else if row < 0 {
			scene.playerPositions[0].row = GameStructure.rows
		} else if col > GameStructure.cols {
			scene.playerPositions[0].col = 0
		} else if col < 0 {
			scene.playerPositions[0].col = GameStructure.cols
		}
		
		renderChange()
	}
	
	// MARK: swipe
	public func swipe(direction: UISwipeGestureRecognizer.Direction) {
		
		// 1. avoid the conflict
		// if we are moving down, we cannot move up (same rule for other direction as well)
		
		switch direction {
		case .down:
			if currentDirection == PlayerDirection.up {
				print("🧨 Conflict: Right now the direction is up, you cannot change it to down")
				return
			} else if currentDirection == PlayerDirection.down {
				print("Same direction: Down")
				return
			} else {
				currentDirection = PlayerDirection.down
			}
		case .up:
			if currentDirection == PlayerDirection.down {
				print("🧨 Conflict: Right now the direction is down, you cannot change it to up")
				return
			} else if currentDirection == PlayerDirection.up {
				print("Same direction: Up")
				return
			} else {
				currentDirection = PlayerDirection.up
			}
		case .left:
			if currentDirection == PlayerDirection.right {
				print("🧨 Conflict: Right now the direction is right, you cannot change it to left")
				return
			} else if currentDirection == PlayerDirection.left {
				print("Same direction: Left")
				return
			} else {
				currentDirection = PlayerDirection.left
			}
		case .right:
			if currentDirection == PlayerDirection.left {
				print("🧨 Conflict: Right now the direction is left, you cannot change it to right")
				return
			} else if currentDirection == PlayerDirection.right {
				print("Same direction: right")
				return
			} else {
				currentDirection = PlayerDirection.right
			}
		default: break
		}
		
		updatePlayerPosition(direction: currentDirection)
	}
}
