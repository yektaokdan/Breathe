import SwiftUI
struct BreathingSession: Codable, Identifiable {
    let id: UUID
    let duration: Int // saniye cinsinden
    let pattern: BreathingPattern
    let date: Date
    
    init(duration: Int, pattern: BreathingPattern) {
        self.id = UUID()
        self.duration = duration
        self.pattern = pattern
        self.date = Date()
    }
}

struct BreathingPattern: Codable {
    let inhale: Int // saniye cinsinden
    let hold: Int
    let exhale: Int
    let name: String
    
    static let defaultPattern = BreathingPattern(
        inhale: 4,
        hold: 4,
        exhale: 4,
        name: "4-4-4"
    )
} 
