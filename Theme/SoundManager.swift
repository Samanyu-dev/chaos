import Foundation
import AVFoundation
import UIKit

enum OscType {
    case sine
    case triangle
}

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    // Core Engine Instances
    private let sampleRate: Float = 44100.0
    
    // Play a synthesized frequency tone on-the-fly
    func playSynthTone(frequency: Float, duration: Double, type: OscType, sweepTo: Float? = nil) {
        // Run audio synthesizer off main thread
        DispatchQueue.global(qos: .userInteractive).async {
            let engine = AVAudioEngine()
            let player = AVAudioPlayerNode()
            
            engine.attach(player)
            
            guard let format = AVAudioFormat(standardFormatWithSampleRate: Double(self.sampleRate), channels: 1) else { return }
            engine.connect(player, to: engine.mainMixerNode, format: format)
            
            let frameCount = AVAudioFrameCount(duration * Double(self.sampleRate))
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
            buffer.frameLength = frameCount
            
            guard let floatData = buffer.floatChannelData else { return }
            let channel = floatData[0]
            
            for i in 0..<Int(frameCount) {
                let t = Float(i) / self.sampleRate
                var currentFreq = frequency
                
                if let endFreq = sweepTo {
                    let progress = Float(i) / Float(frameCount)
                    currentFreq = frequency + (endFreq - frequency) * progress
                }
                
                let theta = 2.0 * Float.pi * currentFreq * t
                var sample: Float = 0
                
                switch type {
                case .sine:
                    sample = sin(theta)
                case .triangle:
                    sample = abs((theta / Float.pi).truncatingRemainder(dividingBy: 2.0) - 1.0) * 2.0 - 1.0
                }
                
                // Anti-click exponential fade out
                let fadeStart = Int(Float(frameCount) * 0.7)
                if i > fadeStart {
                    let progress = Float(i - fadeStart) / Float(Int(frameCount) - fadeStart)
                    sample *= (1.0 - progress)
                }
                
                // Safe volume ceiling
                channel[i] = sample * 0.12
            }
            
            do {
                try engine.start()
                player.play()
                player.scheduleBuffer(buffer) {
                    // Stop & teardown engine
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
                        engine.stop()
                    }
                }
            } catch {
                print("Synth engine error: \(error)")
            }
        }
    }
    
    // MARK: - Premium Tones
    
    func playClick() {
        playSynthTone(frequency: 960, duration: 0.06, type: .sine)
        triggerHaptic(style: .light)
    }
    
    func playTransition() {
        playSynthTone(frequency: 440, duration: 0.35, type: .sine, sweepTo: 880)
        triggerHaptic(style: .medium)
    }
    
    func playOrbSound() {
        playSynthTone(frequency: 587.33, duration: 0.35, type: .sine, sweepTo: 1174.66) // D5 to D6 magical glide
        triggerHaptic(style: .soft)
    }
    
    func playMapPulse() {
        playSynthTone(frequency: 180, duration: 0.5, type: .sine, sweepTo: 90) // Low sonar swoop down
        triggerHaptic(style: .soft)
    }
    
    func playTick() {
        playSynthTone(frequency: 1320, duration: 0.015, type: .triangle)
        triggerHaptic(style: .light)
    }
    
    func playSuccess() {
        // Fast ascending chime arpeggio
        playSynthTone(frequency: 523.25, duration: 0.1, type: .sine)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playSynthTone(frequency: 659.25, duration: 0.1, type: .sine)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            self.playSynthTone(frequency: 783.99, duration: 0.1, type: .sine)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            self.playSynthTone(frequency: 1046.50, duration: 0.25, type: .sine)
            self.triggerHapticNotification(type: .success)
        }
    }
    
    // MARK: - Tactile Haptic System
    
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func triggerHapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
