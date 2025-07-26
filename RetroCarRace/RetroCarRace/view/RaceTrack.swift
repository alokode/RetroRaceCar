//
//  RaceTrack.swift
//  RetroCarRace
//
//  Created by Alok Sagar on 06/08/24.
//

import SwiftUI
import Combine

enum PlayerCarMovment{
    case left,right,none
}

struct RaceTrack: View {
    let columns: Int = 10 // Fixed number of columns
    let spacing: CGFloat = 2 //  spacing between pixels
    @State  var cars:[Car] = []
    @State  var timerCount: Int = 0
    @State  var borderMovementFlag: Bool = false
    @ObservedObject  var raceTrackInfo:RaceTrackInfo
    @State private var timer:Timer.TimerPublisher?
    @State private var raceTrackTimerCancellable: AnyCancellable?
    @State private var timerInterval: Double = 1.0
    @State private var previousTimerInterval: Double = 1.0
    @State private var rowscount : Int = 0
    @State private var explosionTimerCancellable: AnyCancellable?
    var carPosOffSetY: Int = 0
    @State private var animationToggle: Bool = false
    @State private var isCollide: Bool = false
    @State private var pixelRotationAngle:Double = 0
    @State private var collidedCar : Car?

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let totalHeight = geometry.size.height
            
            // Calculate the width and height of each rectangle
            let availableWidth = totalWidth - (spacing * CGFloat(columns - 1))
            let rectangleWidth = availableWidth / CGFloat(columns)
            let numberOfRows = Int((totalHeight + spacing) / (rectangleWidth + spacing))
            
            let rectangleHeight = (totalHeight - (spacing * CGFloat(numberOfRows - 1))) / CGFloat(numberOfRows)
            VStack(spacing: spacing) {
                ForEach(0..<numberOfRows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { column in
                           
                            Pixel(rectSize: rectangleWidth,isActive: isPixelActiveForCar(row, column:column))
                                .rotationEffect(.degrees(isPixesForCollidedCars(row, column: column) ? pixelRotationAngle : 0))
                    
                        }
                    }
                }
            }
            .frame(width: totalWidth, height: totalHeight)
            .background(screenBackground)
            .onAppear(perform: {
                self.rowscount = numberOfRows
            })
            .onChange(of: raceTrackInfo.playerCarMovement, {
                movePlayer(newMovement: raceTrackInfo.playerCarMovement)
            })
            .onChange(of: raceTrackInfo.pause) {
                if raceTrackInfo.pause {
                    raceTrackTimerCancellable?.cancel()
                }else {
                    setupTimer()
                }
            }
            .onChange(of: raceTrackInfo.resetFlag) {
                if raceTrackInfo.resetFlag {
                  resetRaceTrack()
                }
            }
            .onChange(of: isCollide) {
                if isCollide {
                    MediaManager.shared.playSound(type: .collision)
                }
               
            }
        }
        .onAppear(perform: {
           resetRaceTrack()
        })
        .onChange(of: raceTrackInfo.fastMode) {
            setupTimer()
        }
    }
    
    private func movePlayer(newMovement:PlayerCarMovment){
        if isCollide {return}
        for (_, car) in cars.enumerated() {
                       if car.carType == .player {
                           guard let headPixel = car.headPixel else { break }
                           if newMovement == .right && (headPixel.col <= 6) {
                               car.moveRight()
                           } else if newMovement == .left && ( headPixel.col >= 2) {
                               car.moveLeft()
                           }
                           break
                       }
                   }
        raceTrackInfo.playerCarMovement = .none
    }
    private func resetRaceTrack(){
        MediaManager.shared.playSound(type: .reset)
        raceTrackTimerCancellable?.cancel()
        isCollide = false
        var playerCarObj = getPlayerCar()
        cars.removeAll()
        cars = [Car(pixels: randomCarPositionNew(startRectPixel: CarPixelPosition(row: -5, col: [0,3,6].randomElement()!)), type: .opponent) ,playerCarObj]
        timerInterval = 1
        previousTimerInterval = 1
        setupTimer()
        raceTrackInfo.resetFlag = false
        
    }
    
     func isCarReachedBottom(car:Car,limit:Int) -> Bool {
        ////print("firt row : \(car.firstRowPos)")
         return car.firstRowPos > limit
    }
    
     var carPixels : [[Int]] = [[0,1],[1,0],[1,1],[1,3],[2,1],[2,0],[2,1],[2,3]]
             
     var randomCar : Car {
         return Car.init(pixels: randomCarPositionNew(startRectPixel: CarPixelPosition(row: [0,-4,-8].randomElement()!, col: [0,3,6].randomElement()!)), type: .opponent)
    }
    
    private func getPlayerCar() -> Car {
        return Car.init(pixels: randomCarPositionNew(startRectPixel: CarPixelPosition(row: rowscount-5, col: 4)), type: .player)
   }
    
    
     func randomCarPosition(startCol:Int) -> [CarPixelPosition] {
        [
            //1
            CarPixelPosition(row: 0, col: startCol),
            
            CarPixelPosition(row: 1, col: startCol-1),
            CarPixelPosition(row: 1, col: startCol),
            CarPixelPosition(row:1, col: startCol+1),
            
           
            CarPixelPosition(row: 2, col: startCol),
           
            
            CarPixelPosition(row: 3, col: startCol-1),
            CarPixelPosition(row: 3, col: startCol),
            CarPixelPosition(row: 3, col: startCol+1)
            
        ]
    }
    
     func randomCarPositionNew(startRectPixel:CarPixelPosition) -> [CarPixelPosition] {
        [
            //1
            CarPixelPosition(row: startRectPixel.row, col: startRectPixel.col+1),
            
            CarPixelPosition(row: startRectPixel.row+1, col: startRectPixel.col),
            CarPixelPosition(row:  startRectPixel.row+1, col: startRectPixel.col+1),
            CarPixelPosition(row: startRectPixel.row+1, col: startRectPixel.col+2),
            
           
            CarPixelPosition(row: startRectPixel.row+2, col: startRectPixel.col+1),
           
            
            CarPixelPosition(row: startRectPixel.row+3, col: startRectPixel.col),
            CarPixelPosition(row: startRectPixel.row+3, col: startRectPixel.col+1),
            CarPixelPosition(row: startRectPixel.row+3, col: startRectPixel.col+2)
            
        ]
    }
    
func isPixelActiveForCar(_ row: Int, column: Int) -> Bool {
       for car in cars {
           for carPixel in car.pixels {
               if row == carPixel.row &&  column == carPixel.col {
                   return true
               }
           }
       }

       if  column == (columns - 1) {
           // Determine color for first and last columns based on the row index
           let patternRow = (row + (borderMovementFlag ? 0 : 1)) % 3
           return patternRow == 0 || patternRow == 1
       } else {
           return false
       }
   }
    
    func isPixesForCollidedCars(_ row: Int, column: Int) -> Bool{
        guard let _ = collidedCar, let playerCar = cars.filter({$0.carType == .player}).first else {return false}
        for car in [collidedCar,playerCar] {
            for carPixel in car!.pixels {
                if row == carPixel.row &&  column == carPixel.col {
                    return true
                }
            }
        }
        return false
    }
    
     func colorForRow(_ row: Int, column: Int, toggle: Bool) -> Color {
        for car in cars {
            for carPixel in car.pixels {
                if row == carPixel.row &&  column == carPixel.col {
                    return .red
                }
            }
        }

        if  column == (columns - 1) {
            // Determine color for first and last columns based on the row index
            let patternRow = (row + (toggle ? 0 : 1)) % 3
            return patternRow == 0 || patternRow == 1 ? .red : .black
        } else {
            return .black // Default color for non-first and non-last columns
        }
    }
     func introduceCar() -> [CarPixelPosition]{
        return [
            CarPixelPosition(row: carPosOffSetY+1, col: 1),
            
            CarPixelPosition(row: carPosOffSetY+1, col: 0),
            CarPixelPosition(row: carPosOffSetY+1, col: 1),
            CarPixelPosition(row: carPosOffSetY+1, col: 2),
            
           
            CarPixelPosition(row: carPosOffSetY+2, col: 1),
           
            
            CarPixelPosition(row: carPosOffSetY+3, col: 0),
            CarPixelPosition(row: carPosOffSetY+3, col: 1),
            CarPixelPosition(row: carPosOffSetY+3, col: 2)
            
        ]
    }
    
    private func explosion(car: Car) {
        explosionTimerCancellable?.cancel()
        raceTrackTimerCancellable = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect().sink(receiveValue: { _ in
            let head = car.headPixel
            withAnimation {
                car.pixels.removeAll()
                car.pixels.append(head!)
                
                head?.incrementCol()
                head?.incrementCol()
                head?.incrementCol()
               // cars.append(car)
            }
        })
    }
    
    private func setupTimer() {
    
        raceTrackTimerCancellable?.cancel()
        if raceTrackInfo.fastMode {
            previousTimerInterval = timerInterval
        }
        //print("#ALK Prev \(previousTimerInterval)" )
        timerInterval = raceTrackInfo.fastMode  ? 0.2 : previousTimerInterval
        //print("#ALK Current \(timerInterval)" )
            raceTrackTimerCancellable = Timer.publish(every: timerInterval, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    withAnimation {
                       
                        let playerCar = cars.filter {$0.carType == .player}.first
                        
                        if isCollide {
                            pixelRotationAngle = (pixelRotationAngle == 180 ? 0 : 180)
                            
                            return
                        }
                       // if !raceTrackInfo.fastMode {
                            raceTrackInfo.score += 10
                        raceTrackInfo.highScore = raceTrackInfo.highScore < raceTrackInfo.score ?  raceTrackInfo.score : raceTrackInfo.highScore
                        //}
                        
                        borderMovementFlag.toggle()
                        for (_,car) in cars.enumerated() {
                           
                            if car.carType == .opponent {
                                car.moveDown()
                                if isCarReachedBottom(car: car,limit:rowscount){
                                }
                               
                                if car.iscollideWith(playerCar!) {
                                    collidedCar = car
                                   isCollide  = true
                                   //raceTrackTimerCancellable?.cancel()
                                
                                }
                            }else {
                               // car.moveLeft()
                            }
                            

                        }
                        cars = cars.filter {
                            !isCarReachedBottom(car: $0, limit: rowscount)
                        }
                        
                      //  cars.append(randomCar)
                        ////print("#Cars count \(cars.count)")
                        
                    
                        timerCount += 1
                        if timerCount % 10 == 0 {
                            var newCar = Car(pixels: randomCarPositionNew(startRectPixel: CarPixelPosition(row: -5, col: [0,3,6].randomElement()!)), type: .opponent)
                            cars.append(newCar)
                            if !raceTrackInfo.fastMode && timerInterval >= 0.15 {
                                MediaManager.shared.playSound(type: .speedup)
                                raceTrackInfo.speed += 1
                                timerInterval = timerInterval - 0.07
                                previousTimerInterval = timerInterval
                                //print("#ALK time interval  increased \(timerInterval)")
                                setupTimer()
                            }
                            
                        }
                        
                       
                    
                        if cars.count < 3 {
                       //     cars.append(newCar)
                        }

                    }
                }
        }
    
    func updateCount(count:Int){
        rowscount = count
    }
   
    
}

class CarPixelPosition:Equatable,NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CarPixelPosition(row: self.row, col: col)
            return copy
    }
    
    static func == (lhs: CarPixelPosition, rhs: CarPixelPosition) -> Bool {
       return  (lhs.row == rhs.row && lhs.col == rhs.col)
    }
    
    func printPosition(){
        //print("(\(row),\(col))")
    }

    var row:Int
    var col:Int
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
   
    func incrementRow() {
        row = row + 1
    }
    func incrementCol() {
        col = col + 1
    }
    func decrementRow() {
        row = row - 1
    }
    func decrementCol() {
        col = col - 1
    }
}

enum CarType {
    case player,opponent
}
class Car {
    var carType:CarType = .player
    var pixels:[CarPixelPosition]
    var firstRowPos:Int = 0
    var headPixel:CarPixelPosition? {
        pixels.first as? CarPixelPosition
    }
    
    var initialPixels:[CarPixelPosition] = []
    func printCarPixels(){
        for pixel in pixels {
            pixel.printPosition()
        }
    }
    init(pixels: [CarPixelPosition],type:CarType) {
        self.pixels = pixels
        self.carType = type
        firstRowPos = self.pixels.min(by: {$0.row < $1.row})?.row ?? 0
    }
     func moveDown(){
        for var pixel in pixels {
            pixel.incrementRow()
        }
         firstRowPos = self.pixels.min(by: {$0.row < $1.row})?.row ?? 0
    }
    func moveLeft(){
       for var pixel in pixels {
           pixel.decrementCol()
       }
       // firstRowPos = self.pixels.min(by: {$0.row < $1.row})?.row ?? 0
   }
    
    func moveRight(){
       for var pixel in pixels {
           pixel.incrementCol()
       }
       // firstRowPos = self.pixels.min(by: {$0.row < $1.row})?.row ?? 0
   }
    
    func iscollideWith(_ secondCar:Car) -> Bool{
        for pixel in self.pixels {
                if secondCar.pixels.contains(pixel) {
                    return true
                }
            }
            return false
    }
}

#Preview {
    @State var fastMode = false
    @StateObject var raceTrackInfo = RaceTrackInfo()
    //@State var rotationAngle:Double = 0
    return RaceTrack( raceTrackInfo: raceTrackInfo)
}
