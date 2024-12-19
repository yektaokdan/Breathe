import Foundation
import Combine

class BreathingViewModel: ObservableObject {
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var timeRemaining: Int = 0
    @Published var isActive: Bool = false
    @Published var pattern: BreathingPattern = .defaultPattern
    
    @Published var soundEnabled: Bool = true
    @Published var hapticsEnabled: Bool = true
    
    private var timer: Timer?
    private var sessionHistory: [BreathingSession] = []
    
    enum BreathingPhase {
        case inhale
        case hold
        case exhale
    }
    
    func startSession() {
        isActive = true
        currentPhase = .inhale
        timeRemaining = pattern.inhale
        
        if hapticsEnabled {
            HapticManager.shared.playSessionStart()
        }
        if soundEnabled {
            SoundManager.shared.playBreathSound(for: .inhale)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func stopSession() {
        isActive = false
        timer?.invalidate()
        timer = nil
        
        if hapticsEnabled {
            HapticManager.shared.playSessionEnd()
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            moveToNextPhase()
        }
    }
    
    private func moveToNextPhase() {
        if hapticsEnabled {
            HapticManager.shared.playPhaseTransition()
        }
        
        switch currentPhase {
        case .inhale:
            currentPhase = .hold
            timeRemaining = pattern.hold
            if soundEnabled {
                SoundManager.shared.playBreathSound(for: .hold)
            }
        case .hold:
            currentPhase = .exhale
            timeRemaining = pattern.exhale
            if soundEnabled {
                SoundManager.shared.playBreathSound(for: .exhale)
            }
        case .exhale:
            currentPhase = .inhale
            timeRemaining = pattern.inhale
            if soundEnabled {
                SoundManager.shared.playBreathSound(for: .inhale)
            }
        }
    }
    
    func updatePattern(inhale: Int? = nil, hold: Int? = nil, exhale: Int? = nil) {
        let newPattern = BreathingPattern(
            inhale: inhale ?? pattern.inhale,
            hold: hold ?? pattern.hold,
            exhale: exhale ?? pattern.exhale,
            name: "\(inhale ?? pattern.inhale)-\(hold ?? pattern.hold)-\(exhale ?? pattern.exhale)"
        )
        pattern = newPattern
    }
} 