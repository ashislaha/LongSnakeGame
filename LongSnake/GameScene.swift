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
	
	override func didMove(to view: SKView) {
		initialise()
		
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
	
	private func playButtonTapped() {
		print("play button tapped")
		
	}
}
