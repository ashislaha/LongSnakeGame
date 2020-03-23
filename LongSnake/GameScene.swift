//
//  GameScene.swift
//  LongSnake
//
//  Created by Ashis Laha on 23/03/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Constants {
	static let playButtonName = "play_button"
}


class GameScene: SKScene {
	
	var gameManager = GameManager()
	
	private var gameBackground: SKShapeNode!
	private var playerPositions: [(Int, Int)] = []
	private var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
	
	// add some level
	private var gameLogo: SKLabelNode = {
		let gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
		gameLogo.zPosition = 1
		gameLogo.fontSize = 50
		gameLogo.text = "Snake 🐍"
		gameLogo.fontColor = .red
		return gameLogo
	}()
	
	private var bestScore: SKLabelNode = {
		let bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
		bestScore.zPosition = 1
		bestScore.fontColor = .green
		bestScore.text = "Best score: "
		bestScore.fontSize = 40
		return bestScore
	}()
	
	// add a play button
	private var playButton: SKShapeNode = {
		let playButton = SKShapeNode()
		playButton.name = Constants.playButtonName
		playButton.zPosition = 1
		playButton.fillColor = .cyan
		
		let top = CGPoint(x: -50, y: -50)
		let bottom = CGPoint(x: -50, y: 50)
		let right = CGPoint(x: 50, y: 0)
		let path = CGMutablePath()
		path.addLine(to: top)
		path.addLines(between: [top, bottom, right])
		playButton.path = path
		
		return playButton
	}()
	
	// current score
	private var currentScore: SKLabelNode = {
		let node = SKLabelNode(fontNamed: "ArialRoundedMTBold")
		node.zPosition = 1
		node.fontSize = 40
		node.fontColor = .green
		node.isHidden = true
		node.text = "Current Score: "
		return node
	}()
	
	
	override func didMove(to view: SKView) {
		initialise()
		gameViewInitialise()
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
	
	private func initialise() {
		
		[gameLogo, bestScore, playButton].forEach { addChild($0) }
		gameLogo.position = .zero
		bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
		playButton.position = CGPoint(x: 0, y: bestScore.position.y - 200)
	}
	
	// MARK: Touch events
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// check if the user touches on playButton node
		for touch in touches {
			let location = touch.location(in: self)
			let touchNodes = nodes(at: location)
			
			for node in touchNodes {
				if let nodeName = node.name, nodeName == Constants.playButtonName {
					playButtonTapped()
				}
			}
		}
	}
	
	// MARK: Play Button Tapped
	private func playButtonTapped() {
		print("play button tapped")
		
		gameLogo.run(SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 0.5)) {
			self.gameLogo.isHidden = true
		}
		
		let y = frame.size.height / 2
		bestScore.run(SKAction.moveBy(x: 0, y: y - 50, duration: 0.5)) {
			self.gameBackground.isHidden = false
			self.gameBackground.setScale(0)
			self.currentScore.isHidden = false
			self.currentScore.setScale(0)
			
			self.gameBackground.run(SKAction.scale(to: 1.0, duration: 0.5))
			self.currentScore.run(SKAction.scale(to: 1.0, duration: 0.5))
		}
		
		playButton.run(SKAction.scale(to: 0.0, duration: 0.5)) {
			self.playButton.isHidden = true
		}
	}
	
	// MARK: Game view initialise
	private func gameViewInitialise() {
		
		currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 100)
		addChild(currentScore)
		
		let width = frame.size.width - 200
		let height = frame.size.height - 300
		let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
		gameBackground = SKShapeNode(rect: rect)
		gameBackground.fillColor = .gray
		gameBackground.zPosition = 2
		gameBackground.isHidden = true
		addChild(gameBackground)
		
		createGameBoard(width: width, height: height)
	}
	private func createGameBoard(width: CGFloat, height: CGFloat) {
		let cellWidth: CGFloat = 27.5
		let numRows = 38
		let numCols = 20
		var x = CGFloat(width / -2) + (cellWidth / 2)
		var y = CGFloat(height / 2) - (cellWidth / 2)
		
		//loop through rows and columns, create cells
		for i in 0...numRows - 1 {
			for j in 0...numCols - 1 {
				let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
				cellNode.strokeColor = SKColor.black
				cellNode.zPosition = 2
				cellNode.position = CGPoint(x: x, y: y)
				//add to array of cells -- then add to game board
				gameArray.append((node: cellNode, x: i, y: j))
				gameBackground.addChild(cellNode)
				//iterate x
				x += cellWidth
			}
			//reset x, iterate y
			x = CGFloat(width / -2) + (cellWidth / 2)
			y -= cellWidth
		}
	}
	
}
