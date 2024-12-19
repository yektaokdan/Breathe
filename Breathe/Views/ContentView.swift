import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BreathingViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BreatheColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    BreathingCircleView(viewModel: viewModel)
                        .padding()
                    
                    Text(phaseText)
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(BreatheColors.text)
                        .animation(.easeInOut, value: viewModel.currentPhase)
                    
                    Text("\(viewModel.timeRemaining)")
                        .font(.system(size: 60, weight: .light, design: .rounded))
                        .foregroundColor(BreatheColors.text)
                    
                    Button(action: {
                        if viewModel.isActive {
                            viewModel.stopSession()
                        } else {
                            viewModel.startSession()
                        }
                    }) {
                        Text(viewModel.isActive ? "Durdur" : "Başla")
                            .font(.system(.title2, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(
                                viewModel.isActive ? 
                                BreatheColors.inhale : .white
                            )
                            .cornerRadius(25)
                            .shadow(radius: 5, y: 2)
                    }
                }
            }
            .navigationTitle("Nefes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .foregroundColor(BreatheColors.text)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
    
    private var phaseText: String {
        switch viewModel.currentPhase {
        case .inhale: return "Nefes Al"
        case .hold: return "Tut"
        case .exhale: return "Nefes Ver"
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BreathingViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Nefes Paterni") {
                    Stepper("Nefes Alma: \(viewModel.pattern.inhale) sn", 
                           value: Binding(
                            get: { viewModel.pattern.inhale },
                            set: { viewModel.updatePattern(inhale: $0) }
                           ), in: 2...10)
                    
                    Stepper("Tutma: \(viewModel.pattern.hold) sn",
                           value: Binding(
                            get: { viewModel.pattern.hold },
                            set: { viewModel.updatePattern(hold: $0) }
                           ), in: 0...10)
                    
                    Stepper("Nefes Verme: \(viewModel.pattern.exhale) sn",
                           value: Binding(
                            get: { viewModel.pattern.exhale },
                            set: { viewModel.updatePattern(exhale: $0) }
                           ), in: 2...10)
                }
                
                Section("Ses ve Titreşim") {
                    Toggle("Ses Efektleri", isOn: $viewModel.soundEnabled)
                    Toggle("Titreşim", isOn: $viewModel.hapticsEnabled)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tamam") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
