import SpriteKit

class CountdownLabel: SKLabelNode {
    private var endTime: Date!
    private var isTimerPaused = false
    private var pausedTimeRemaining: TimeInterval = 0
    
    func update() {
        if !isTimerPaused {
            let timeLeftInteger = Int(timeLeft())
            text = String(timeLeftInteger)
        }
        else {
            let timeLeftInteger = Int(pausedTimeRemaining)
            text = String(timeLeftInteger)
        }
    }
    
    func startWithDuration(duration: TimeInterval) {
        let timeNow = Date()
        endTime = timeNow.addingTimeInterval(duration)
    }
    
    func hasFinished() -> Bool {
        return timeLeft() == 0
    }
    
    func pause() {
        if !isTimerPaused {
            pausedTimeRemaining = timeLeft()
            isTimerPaused = true
            update()
//            print("PAUSE")
//            print(pausedTimeRemaining)
        }
    }
    
    func resume() {
        if isTimerPaused {
            isTimerPaused = false
            let timeNow = Date()
            endTime = timeNow.addingTimeInterval(pausedTimeRemaining-1)
//            print("RESUME")
//            print(pausedTimeRemaining)
            update()
        }
    }
    
    func timeLeft() -> TimeInterval {
        if isTimerPaused {
            return pausedTimeRemaining
        } else {
            let now = Date()
            let remainingSeconds = endTime.timeIntervalSince(now)
            return max(remainingSeconds, 0)
        }
    }
    
    func addTime(amount: Int) {
        pausedTimeRemaining += Double(amount)
        print(pausedTimeRemaining)
        text = String(Int(pausedTimeRemaining))
        print(text)
    }
}
