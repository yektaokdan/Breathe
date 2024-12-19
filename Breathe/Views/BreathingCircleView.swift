import SwiftUI

struct BreathingCircleView: View {
    @ObservedObject var viewModel: BreathingViewModel
    
    var body: some View {
        ZStack {
            // Sabit arka plan
            BreatheColors.background
                .ignoresSafeArea()
            
            // Arka plan halkası
            Circle()
                .stroke(phaseColor.opacity(0.3), lineWidth: 30)
                .frame(width: 280, height: 280)
            
            // Animasyonlu halka
            Circle()
                .trim(from: 0, to: progressForPhase)
                .stroke(
                    phaseColor,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))
                .animation(
                    Animation.easeInOut(duration: 1)
                    .repeatCount(1, autoreverses: false),
                    value: progressForPhase
                )
            
            // İç dolgu
            Circle()
                .fill(phaseColor.opacity(0.1))
                .frame(width: 240, height: 240)
                .scaleEffect(viewModel.isActive ? 1.1 : 1.0)
                .animation(
                    Animation.easeInOut(duration: Double(viewModel.pattern.inhale))
                    .repeatForever(autoreverses: true),
                    value: viewModel.isActive
                )
        }
    }
    
    private var phaseColor: Color {
        switch viewModel.currentPhase {
        case .inhale: return BreatheColors.inhale
        case .hold: return BreatheColors.hold
        case .exhale: return BreatheColors.exhale
        }
    }
    
    private var progressForPhase: Double {
        guard viewModel.isActive else { return 0 }
        
        let total: Double
        switch viewModel.currentPhase {
        case .inhale: total = Double(viewModel.pattern.inhale)
        case .hold: total = Double(viewModel.pattern.hold)
        case .exhale: total = Double(viewModel.pattern.exhale)
        }
        
        return 1.0 - (Double(viewModel.timeRemaining) / total)
    }
} 