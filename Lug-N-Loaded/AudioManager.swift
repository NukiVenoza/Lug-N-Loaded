import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var obstructionMusicPlayer : AVAudioPlayer?
    private var rushMusicPlayer : AVAudioPlayer?
    private var winMusicPlayer : AVAudioPlayer?
    private var loseMusicPlayer : AVAudioPlayer?
    
    private var isBackgroundMusicPaused = false
    private var backgroundMusicPausedTime: TimeInterval = 0.0
    
    private init() {
        // Initialize the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.ambient, mode: .default)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    func playBackgroundMusic(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("Failed to play background music: \(error)")
            }
        } else {
            print("Background music file not found.")
        }
    }
    
    func playObstructionMusic(filename : String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                obstructionMusicPlayer = try AVAudioPlayer(contentsOf: url)
                obstructionMusicPlayer?.numberOfLoops = -1
                obstructionMusicPlayer?.prepareToPlay()
                obstructionMusicPlayer?.play()
            } catch {
                print("Failed to play obstruction music: \(error)")
            }
        } else {
            print("Obstruction music file not found.")
        }
    }
    
    func playRushMusic(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                rushMusicPlayer = try AVAudioPlayer(contentsOf: url)
                rushMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                rushMusicPlayer?.prepareToPlay()
                rushMusicPlayer?.play()
            } catch {
                print("Failed to play rush music: \(error)")
            }
        } else {
            print("Rush music file not found.")
        }
    }
    
    func playWinMusic(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                winMusicPlayer = try AVAudioPlayer(contentsOf: url)
                winMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                winMusicPlayer?.prepareToPlay()
                winMusicPlayer?.play()
            } catch {
                print("Failed to play win music: \(error)")
            }
        } else {
            print("Win music file not found.")
        }
    }
    
    func playLoseMusic(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                loseMusicPlayer = try AVAudioPlayer(contentsOf: url)
                loseMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                loseMusicPlayer?.prepareToPlay()
                loseMusicPlayer?.play()
            } catch {
                print("Failed to play lose music: \(error)")
            }
        } else {
            print("Lose music file not found.")
        }
    }
    
    func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer, player.isPlaying {
            player.pause()
            isBackgroundMusicPaused = true
            backgroundMusicPausedTime = player.currentTime
        }
    }
    
    func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer, isBackgroundMusicPaused {
            player.currentTime = backgroundMusicPausedTime
            player.play()
            isBackgroundMusicPaused = false
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
        isBackgroundMusicPaused = false
        backgroundMusicPausedTime = 0.0
    }
    
    func stopObstructionMusic() {
        obstructionMusicPlayer?.stop()
        obstructionMusicPlayer = nil
    }
    
    func stopRushMusic() {
        rushMusicPlayer?.stop()
        rushMusicPlayer = nil
    }
    
    func stopWinMusic() {
        winMusicPlayer?.stop()
        winMusicPlayer = nil
    }
    
    func stopLoseMusic() {
        loseMusicPlayer?.stop()
        loseMusicPlayer = nil
    }
}
