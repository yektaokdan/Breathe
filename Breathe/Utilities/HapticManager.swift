import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func playPhaseTransition() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    func playSessionStart() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func playSessionEnd() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
} 