import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBreathSound(for phase: BreathingViewModel.BreathingPhase) {
        let soundName: String
        switch phase {
        case .inhale: soundName = "inhale"
        case .hold: soundName = "hold"
        case .exhale: soundName = "exhale"
        }
        
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Ses dosyası çalınamadı: \(error.localizedDescription)")
        }
    }
} 