//
//  Game.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameManager {
    weak var audioPlayer: AVAudioPlayer?
    weak var viewController: GameScreenViewController!
    var play = true
    var gameStarted = false
    var mazeGenerated = false
    var matrix = [[Int]]()
//    var mazeMatrix = [[Int]]()
    var moveInstructions = [Int]()
    var pathBlockCordinates = [Tuple]()
    var pathBlockCordinatesNotReversed = [Tuple]()
    var onPathMode = false
    weak var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Float = 1
    var paused = false
    var playerDirection: Int = 3 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var barrierNodesWaitingToBeDisplayed: [SkNodeAndLocation] = []
    var barrierNodesWaitingToBeRemoved: [SkNodeAndLocation] = []
    var snakeBodyPos: [SkNodeAndLocation] = []
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    var foodPosition: [SkNodeAndLocation] = []
    
    var target: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    
    init(scene: GameScene) {
        self.scene = scene
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
    }
    
    // Sort
    var orderedSquareShades: [SkNodeLocationAndColor] = []
    var shuffledSquareShades: [SkNodeLocationAndColor] = []
    
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    
    func roundUp(factor: Int, n: Int) -> Int {
        return (n + 24) / 25 * 25;
    }
    
    
    
    func initaitateRandomSquares() {
        var colorArray = [Float]()
        let playableGameboardSize = scene!.playableGameboardSize
        
        if scene.boardLayoutOption == 5 { // 5 Few Unique
            let divideFactor = playableGameboardSize/6
            for i in 1...playableGameboardSize+1 {
                let newI = roundUp(factor: divideFactor, n: i)
                colorArray.append(1 - Float(newI)/Float(playableGameboardSize))
            }
        } else {
            for i in 0...playableGameboardSize {
                colorArray.append(1 - Float(i)/Float(playableGameboardSize))
            }
        }
        
        // Animation 1: Displays colors in order
        // Use pointers instead of array value removals.
        var colorArrayTwo = colorArray
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor.withAlphaComponent(CGFloat(colorArrayTwo.first ?? 1.0))
                    orderedSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArrayTwo.removeFirst()
                }
            }
        }
        
        if scene.boardLayoutOption == 1 || scene.boardLayoutOption == 2 || scene.boardLayoutOption == 5 { // No Change, Randomize Board, Few Unique
            colorArray.shuffle()
        } else if scene.boardLayoutOption == 3 { // 3 Most
            let arrayCount = Int(colorArray.count/6)
            let upperSortedSquares = (colorArray.count) - arrayCount
            colorArray[arrayCount...upperSortedSquares].shuffle()
        } else if scene.boardLayoutOption == 4 { // 4 Few
            let arrayCount = Int(colorArray.count/6)
            let upperSortedSquares = (colorArray.count) - arrayCount
            colorArray[...arrayCount].shuffle()
            colorArray[upperSortedSquares...].shuffle()
        } else if scene.boardLayoutOption == 6 { // 6 Top
            let validTopSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[...(validTopSquares - 1)].shuffle()
        } else if scene.boardLayoutOption == 7 { // 7 Center
           let validCenterSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[validCenterSquares...((colorArray.count - validCenterSquares) - 2)].shuffle()
        } else if scene.boardLayoutOption == 8 { // 8 Bottom
           let validBottomSquares = ((scene.rowCount - 2)/3) * (scene.columnCount - 2)
            colorArray[((colorArray.count - validBottomSquares) + 1)...].shuffle()
        } else if scene.boardLayoutOption == 9 { // 9 Reverse Sorted
            colorArray.reverse()
        } else if scene.boardLayoutOption == 10 { // 10 Sorted
            // Do nothing
        }
        
        // Animation 2: Squares are suffled
        for (skNodeAndLocation) in scene.gameBoard {
            if skNodeAndLocation.location.x != 0 && skNodeAndLocation.location.x != (scene.rowCount - 1) {
                if skNodeAndLocation.location.y != 0 && skNodeAndLocation.location.y != (scene.columnCount - 1) {
                    skNodeAndLocation.square.fillColor = scene.squareColor.withAlphaComponent(CGFloat(colorArray.first ?? 1.0))
                    shuffledSquareShades.append(SkNodeLocationAndColor(square: skNodeAndLocation.square, location: skNodeAndLocation.location, color: skNodeAndLocation.square.fillColor))
                    colorArray.removeFirst()
                }
            }
        }
        
//        let dupli = scene.gameBoard
        pathSelector(resuming: false)
        
        // Animation 3 Squares are sorted
//        if UserDefaults.standard.integer(forKey: "Selected Maze Algorithim") == 1 {
        let randomX = Int.random(in: 1...7)
        let randomY = Int.random(in: 1...13)
        var targetFound = false
        print(randomX, randomY)
        target.append(scene.gameBoard.first(where: { $0.location == Tuple(x: randomX, y: randomY)})!)
        
        for i in 0...((scene!.gameBoard.count)-scene.columnCount-3) {
            if targetFound == false {
                if scene.gameBoard[i].location.x != 0 && scene.gameBoard[i].location.x != (scene.rowCount - 1) {
                    if scene.gameBoard[i].location.y != 0 && scene.gameBoard[i].location.y != (scene.columnCount - 1) {
                        searchHistory.append(scene.gameBoard[i])
                        if scene.gameBoard[i].location == target[0].location {
                            targetFound = true
                        }
                    }
                }
            } else {
                break
            }
        }
        
//        }
        
//        let old = scene.gameBoard
//        for i in dupli {
//            if i.location.x != 0 && i.location.x != (scene.rowCount - 1) {
//                if i.location.y != 0 && i.location.y != (scene.columnCount - 1) {
//                    old[i].
//                }
//            }
//        }
    }
    
    var visitedNodeArray = [SkNodeAndLocation]()
    func visitedSquareBuilder(visitedX: Int, visitedY: Int) {
        let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: visitedX, y: visitedY)})?.square
        visitedNodeArray.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: visitedX, y: visitedY)))
    }
    
    var fronteerSquareArray = [[SkNodeAndLocation]]()
    func fronteerSquaresBuilder(squareArray: [Tuple]) {
        var innerFronterSKSquareArray = [SkNodeAndLocation]()
        for square in squareArray {
            let squareSK = scene.gameBoard.first(where: {$0.location == Tuple(x: square.y, y: square.x)})?.square
            innerFronterSKSquareArray.append(SkNodeAndLocation(square: squareSK!, location: Tuple(x: square.x, y: square.y)))
        }
        fronteerSquareArray.append(innerFronterSKSquareArray)
    }
    
    
    
    var foodBlocksHaveAnimated = Bool()
//    func spawnFoodBlock() {
//        let foodPalletsNeeded = (UserDefaults.standard.integer(forKey: "Food Count Setting") - foodPosition.count)
//
//        if foodPalletsNeeded > 0 {
//            for _ in 1...foodPalletsNeeded {
//                foodBlocksHaveAnimated = false
//                var randomX = Int.random(in: 1...verticalMaxBoundry)
//                var randomY = Int.random(in: 1...horizontalMaxBoundry)
//
//                var validFoodLocationConfirmed = false
//                var foodLocationChnaged = false
//
//                while validFoodLocationConfirmed == false {
//                    validFoodLocationConfirmed = true
//                    for i in (barrierNodesWaitingToBeDisplayed) {
//                        if i.location.y == randomY && i.location.x == randomX {
//                            randomX = Int.random(in: 1...verticalMaxBoundry)
//                            randomY = Int.random(in: 1...horizontalMaxBoundry)
//                            validFoodLocationConfirmed = false
//                            foodLocationChnaged = true
//                        }
//                    }
//
//                    for i in (snakeBodyPos) {
//                        if i.location.y == randomY && i.location.x == randomX {
//                            randomX = Int.random(in: 1...verticalMaxBoundry)
//                            randomY = Int.random(in: 1...horizontalMaxBoundry)
//                            validFoodLocationConfirmed = false
//                            foodLocationChnaged = true
//                        }
//                    }
//
//                    foodPosition = Array(Set(foodPosition))
//                    if foodLocationChnaged == false {
//                        validFoodLocationConfirmed = true
//                    }
//                }
//                matrix[randomX][randomY] = 3
//                // potential reverseal
//                let node = scene.gameBoard.first(where: {$0.location == Tuple(x: randomX, y: randomY)})?.square
//                foodPosition.append(SkNodeAndLocation(square: node!, location: Tuple(x: randomY, y: randomX)))
//            }
//        }
//        if scene.mazeGeneratingAlgorithimChoice != 0 {
//            if mazeGenerated == false {
////                mazeSelector()
//                mazeGenerated = true
//            }
//        }
//        pathSelector()
//    }
        
    var nnnpath: (([Int], [(Tuple)], Int, Int), [SkNodeAndLocation], [[SkNodeAndLocation]], [SkNodeAndLocation], [Bool])?
    var conditionGreen = Bool()
    var conditionYellow = Bool()
    var conditionRed = Bool()
    
    var pathSquareArray = [SkNodeAndLocation]()
    var displayFronteerSquareArray = [[SkNodeAndLocation]]()
    var displayVisitedSquareArray = [SkNodeAndLocation]()
    var displayPathSquareArray = [SkNodeAndLocation]()
    
    var mazze = [Tuple : [Tuple]]()
    
//    func mazeSelector() {
//        let sceleton = AlgorithmHelper(scene: scene)
//        let dfsp = MazeDepthFirstSearch(scene: scene)
//
//        let mazeGameBoardDictionary = sceleton.gameBoardMatrixToDictionary(gameBoardMatrix: emptyMazeMatrixMaker())
//        let snakeHead = Tuple(x: snakeBodyPos[0].location.y, y: snakeBodyPos[0].location.x)
//
//        if scene.mazeGeneratingAlgorithimChoice == 1 {
//            mazze = dfsp.depthFirstSearchPath(startSquare: snakeHead, foodLocations: foodPosition, gameBoard: mazeGameBoardDictionary, returnPathCost: false, returnSquaresVisited: false)
//        } else {
//            // pass
//        }
//    }
    
    func pathSelector(resuming: Bool) {
        if scene.pathFindingAlgorithimChoice == 0 {
//            var dupli = [SkNodeAndLocation]() as! NSCopying
            let dupli = (scene.gameBoard)
            let bs = BubbleSort(scene: scene)
            swapSquareAndColor = bs.bubbleSort(gameboard: dupli, resuming: resuming)
        } else if scene.pathFindingAlgorithimChoice == 1 {

        } else if scene.pathFindingAlgorithimChoice == 2 {

        } else if scene.pathFindingAlgorithimChoice == 3 {

        } else if scene.pathFindingAlgorithimChoice == 4 {

        } else {
            print("Out Of Bounds Error")
        }
        
//        for i in pathBlockCordinatesNotReversed {
//            let node = scene.gameBoard.first(where: {$0.location == Tuple(x: i.y, y: i.x)})?.square
//            pathSquareArray.append(SkNodeAndLocation(square: node!, location: Tuple(x: i.x, y: i.y)))
//            displayPathSquareArray.append(SkNodeAndLocation(square: node!, location: Tuple(x: i.x, y: i.y)))
//        }
//
//        if scene.pathFindingAlgorithimChoice != 0 {
//            if displayPathSquareArray.count >= 2 {
//                displayPathSquareArray.removeFirst()
//                displayPathSquareArray.removeLast()
//            }
//        }
//
//        if UserDefaults.standard.bool(forKey: "Step Mode On Setting") {
//            // working here may not need
//            UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
//            paused = true
//            checkIfPaused()
//            if scene.gamboardAnimationEnded == true {
//                self.viewController?.reloadStepButtonSettings(isTheGamePaused: true)
//            }
//        } else {
//            if scene.gamboardAnimationEnded == true {
//                // working here may not need
//                self.viewController?.reloadStepButtonSettings(isTheGamePaused: true)
//            } else {
//                // working here may not need
//                UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
//                paused = true
//                checkIfPaused()
//            }
//        }
//
//        if scene.pathFindingAlgorithimChoice != 0 {
//            scene.pathFindingAnimationsHaveEnded = false
//            UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
//            paused = true
//            checkIfPaused()
//        }
//
//        scene.updateScoreButtonHalo()
    }
    
//    func pathManager() {
//        moveInstructions = nnnpath!.0.0
//        moveInstructions = moveInstructions.reversed()
//        pathBlockCordinatesNotReversed = nnnpath!.0.1
//        pathBlockCordinates = pathBlockCordinatesNotReversed.reversed()
//        visitedNodeArray = nnnpath!.1
//        displayVisitedSquareArray = visitedNodeArray
//        fronteerSquareArray = nnnpath!.2
//        displayFronteerSquareArray = fronteerSquareArray
//        pathSquareArray = nnnpath!.3
//        conditionGreen = nnnpath!.4[0]
//        conditionYellow = nnnpath!.4[1]
//        conditionRed = nnnpath!.4[2]
//    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
//    func emptyMazeMatrixMaker() -> [[Int]] {
//        var matrix = [[Int]]()
//        var row = [Int]()
//
//        for _ in 1...Int(ceil(Float(scene.rowCount)/2)) {
//            for _ in 1...Int(ceil(Float(scene.columnCount)/2)) {
//                row.append(0)
//            }
//            matrix.append(row)
//            row = [Int]()
//        }
//        return matrix
//    }
    
//    func runPredeterminedPath() {
//        if gameStarted == true {
//            if (moveInstructions.count != 0) {
//                swipe(ID: moveInstructions[0])
//                moveInstructions.remove(at: 0)
//                if displayPathSquareArray.count != 0 {
//                    displayPathSquareArray.removeLast()
//                }
//                pathBlockCordinates.remove(at: 0)
//                playSound(selectedSoundFileName: "sfx_coin_single3")
//                onPathMode = true
//            } else {
//                onPathMode = false
//                if scene.pathFindingAlgorithimChoice != 0 {
//                    pathSelector()
//                }
//                onPathMode = true
//            }
//        }
//    }
    
    func update(time: Double) {
            
        if nextTime == nil {
            nextTime = time + Double(gameSpeed)
        } else if (paused == true) {
            if gameIsOver != true {
                checkIfPaused()
            }
        }
        else {
            if time >= nextTime! {
//                if gameIsOver != true {
//                    checkForDeath()
//                    updateSnakePosition()
                    if gameIsOver != true {
                        nextTime = time + Double(gameSpeed)
                        barrierSquareManager()
                        scene.updateScoreButtonHalo()
                        scene.updateScoreButtonText()
                        
                        // these two must be together
//                        runPredeterminedPath()
//                        updateSnakePosition()
                        
                        checkIfPaused()
//                        checkForFoodCollision()
                        
//                        checkForDeath()
//                        updateSnakePosition()
                    }
//                }
            }
        }
    }
    
    func barrierSquareManager() {
        barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
        barrierNodesWaitingToBeRemoved.removeAll()
    }
    
    var gameAnimationsWereRemoved = false
    func checkIfPaused() {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") && scene.gamboardAnimationEnded {
            for i in scene.gameBoard {
                i.square.removeAllActions()
                i.square.strokeColor = .clear
                i.square.run(SKAction.scale(to: 1.0, duration: 0))
            }
            gameAnimationsWereRemoved = true
            scene.squareColoringWhileSnakeIsMoving()
            paused = true
        } else {
            if gameAnimationsWereRemoved == true {
                pathSelector(resuming: true)
                gameAnimationsWereRemoved = false
            }
//            scene.animatedVisitedSquareCount = 0
//            scene.animatedQueuedSquareCount = 0
//            gameSpeed = UserDefaults.standard.float(forKey: "Snake Move Speed")
            paused = false
        }
    }
    
    var gameIsOver = Bool()
    func endTheGame() {
        scene.algorithimChoiceName.text = "Game Over"
        self.viewController?.scoreButton.layer.borderColor = UIColor.red.cgColor
//        updateScore()
        gameIsOver = true
        mazeGenerated = false
        currentScore = 0
        scene.animationDualButtonManager(buttonsEnabled: false)
    }
    
    // this is run when game hasent started. fix for optimization.
//    func checkForDeath() {
//        if snakeBodyPos.count > 0 {
//            // Create temp variable of snake without the head.
//            var snakeBody = snakeBodyPos
//            snakeBody.remove(at: 0)
//            // Implement wraping snake in god mode.
//            // If head is in same position as the body the snake is dead.
//            // The snake dies in corners becouse blocks are stacked.
//
//            if !(UserDefaults.standard.bool(forKey: "God Button On Setting")) {
//                if snakeBody.contains(snakeBodyPos[0]) {
//                    endTheGame()
//                }
//            }
//
//            if barrierNodesWaitingToBeDisplayed.contains(snakeBodyPos[0]) {
//                endTheGame()
//            }
//        }
//    }
    
//    var foodCollisionPoint = Int()
//    func checkForFoodCollision() {
//        if foodPosition != nil {
//            let x = snakeBodyPos[0].location.x
//            let y = snakeBodyPos[0].location.y
//            var counter = 0
//
//            for i in (foodPosition) {
//                // potential redudndent casting
//                if Int((i.location.x)) == y && Int((i.location.y)) == x {
//
//                    matrix[Int(i.location.y)][Int(i.location.x)] = 0
//                    foodCollisionPoint = counter
//                    foodPosition.remove(at: foodCollisionPoint)
//
//
//                    spawnFoodBlock()
//                    playSound(selectedSoundFileName: "sfx_coin_double3")
//                    let generator = UIImpactFeedbackGenerator(style: .medium)
//                    generator.impactOccurred()
//
//
//                    // Update the score
//                    if !(UserDefaults.standard.bool(forKey: "God Button On Setting")) {
//                        currentScore += 1
//                        scene.updateScoreButtonText()
//                        updateScore()
//                     }
//
//                    let max = UserDefaults.standard.integer(forKey: "Food Weight Setting")
//                    for _ in 1...max {
//                        snakeBodyPos.append(snakeBodyPos.last!)
//                    }
//                }
//                counter += 1
//            }
//         }
//    }
    
    func playSound(selectedSoundFileName: String) {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        let musicPath = Bundle.main.path(forResource: selectedSoundFileName, ofType:"wav")!
        let url = URL(fileURLWithPath: musicPath)
        
        if UserDefaults.standard.bool(forKey: "Volume On Setting") {
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer = sound
                sound.play()
            } catch {
                print("Error playing file")
            }
        }
    }
    
    func swipe(ID: Int) {
        if scene.pathFindingAlgorithimChoice == 0 && !(UserDefaults.standard.bool(forKey: "God Button On Setting")){
            if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
                if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                playerDirection = ID
                }
            }
        } else {
            playerDirection = ID
        }
    }
    
//    private func updateSnakePosition() {
//        var xChange = -1
//        var yChange = 0
//
//        switch playerDirection {
//            case 1:
//                //left
//                xChange = -1
//                yChange = 0
//                break
//            case 2:
//                //up
//                xChange = 0
//                yChange = -1
//                break
//            case 3:
//                //right
//                xChange = 1
//                yChange = 0
//                break
//            case 4:
//                //down
//                xChange = 0
//                yChange = 1
//                break
//            default:
//                break
//        }
//
//        if snakeBodyPos.count > 0 {
//            var start = snakeBodyPos.count - 1
//            matrix[snakeBodyPos[start].location.x][snakeBodyPos[start].location.y] = 0
//            while start > 0 {
//                snakeBodyPos[start] = snakeBodyPos[start - 1]
//                start -= 1
//            }
//            // Can be reduced only 3 blocks need to be updated.
//            let xx = (snakeBodyPos[0].location.x + yChange)
//            let yy = (snakeBodyPos[0].location.y + xChange)
//            let newSnakeHead = scene.gameBoard.first(where: {$0.location == Tuple(x: xx, y: yy)})
//
//            if newSnakeHead != nil {
//                snakeBodyPos[0] = newSnakeHead!
//            } else {
//                endTheGame()
//            }
//
//            if snakeBodyPos[0].location.x < 0 || snakeBodyPos[0].location.y < 0 {
//                endTheGame()
//            }
//
//            if gameIsOver != true {
//                matrix[snakeBodyPos[0].location.x][snakeBodyPos[0].location.y] = 1
//                matrix[snakeBodyPos[1].location.x][snakeBodyPos[1].location.y] = 2
//            }
//            // Temporary removal
//            matrix[snakeBodyPos[2].location.x][snakeBodyPos[2].location.y] = 2
//            matrix[snakeBodyPos[3].location.x][snakeBodyPos[3].location.y] = 2
//            matrix[snakeBodyPos[4].location.x][snakeBodyPos[4].location.y] = 2
//            matrix[snakeBodyPos[5].location.x][snakeBodyPos[5].location.y] = 2
////            for i in 0...(scene.rowCount-1) {
////                print(matrix[i])
////            }
////            print("----")
//        }
//
//        if gameIsOver != true {
//            if snakeBodyPos.count > 0 {
//                let x = snakeBodyPos[0].location.y
//                let y = snakeBodyPos[0].location.x
//                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
//                    // temporary removal buggy
////                    if y > verticalMaxBoundry { // Moving To Bottom
////                        snakeBodyPos[0].location.x = verticalMinBoundry-1 // Spawning At Top
////                    } else if y < verticalMinBoundry { // Moving to top +1
////                        snakeBodyPos[0].location.x = verticalMaxBoundry+1 // Spawning at bottom
////                    } else if x > horizontalMaxBoundry { // Moving to right
////                        snakeBodyPos[0].location.y = horizontalMinBoundry-1 // Spawning on left
////                    }
////                    else if x < horizontalMinBoundry { // Moving to left +1
////                        snakeBodyPos[0].location.y = horizontalMaxBoundry+1 // Spawning on right
////                    }
//                } else {
//                    if y > verticalMaxBoundry { // Moving To Bottom
//                        endTheGame()
//                    } else if y < verticalMinBoundry { // Moving to top
//                        endTheGame()
//                    } else if x > horizontalMaxBoundry { // Moving to right
//                        endTheGame()
//                    } else if x < horizontalMinBoundry { // Moving to left
//                        endTheGame()
//                    }
//                }
//            }
//            scene.squareColoringWhileSnakeIsMoving()
//        }
//    }

//    func updateScore() {
//        UserDefaults.standard.set(animatedQueuedSquareCount, forKey: "highScore")
//        UserDefaults.standard.set(animatedVisitedSquareCount, forKey: "lastScore")
//    }
}

