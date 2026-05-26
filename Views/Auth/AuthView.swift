import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isSigningUp = false
    @State private var phoneInput = ""
    @State private var otpInput = ""
    @State private var emailInput = ""
    @State private var passwordInput = ""
    
    @State private var showOTPStage = false
    @State private var animateFields = false
    
    var body: some View {
        ZStack {
            // Animating background
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Logo & Header text
                VStack(spacing: 8) {
                    Text("⚡️ ORBIT")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 10)
                    
                    Text("SECURE FRIEND MATRIX TUNNEL")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .kerning(2)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                .padding(.bottom, 30)
                
                // Unified Glassmorphic Authentication Card
                GlassCard(cornerRadius: 28, fillOpacity: 0.12) {
                    VStack(spacing: 20) {
                        // Switch between Entry states
                        HStack(spacing: 0) {
                            Button(action: {
                                SoundManager.shared.playClick()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                                    isSigningUp = false
                                    showOTPStage = false
                                }
                            }) {
                                Text("LOGIN")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(!isSigningUp ? themeManager.currentTheme.primaryText : themeManager.currentTheme.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(!isSigningUp ? .white.opacity(0.06) : .clear)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                SoundManager.shared.playClick()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                                    isSigningUp = true
                                    showOTPStage = false
                                }
                            }) {
                                Text("SIGN UP")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(isSigningUp ? themeManager.currentTheme.primaryText : themeManager.currentTheme.secondaryText)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(isSigningUp ? .white.opacity(0.06) : .clear)
                                    .cornerRadius(12)
                            }
                        }
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(14)
                        .padding(.bottom, 10)
                        
                        if !showOTPStage {
                            // Stage 1: Phone / Credentials entry
                            VStack(spacing: 16) {
                                // Glowing phone input field
                                GlassTextField(placeholder: "Phone Number", icon: "phone.fill", text: $phoneInput)
                                
                                if isSigningUp {
                                    GlassTextField(placeholder: "Email Address", icon: "envelope.fill", text: $emailInput)
                                } else {
                                    GlassSecureField(placeholder: "Secure Password", icon: "lock.fill", text: $passwordInput)
                                }
                                
                                BreathingButton(title: isSigningUp ? "Create Matrix Node" : "Access Tunnel", icon: "arrow.right", isGlowing: true) {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                        showOTPStage = true
                                    }
                                }
                            }
                            .opacity(animateFields ? 1.0 : 0.0)
                            .offset(y: animateFields ? 0 : 20)
                            
                        } else {
                            // Stage 2: OTP Verification
                            VStack(spacing: 18) {
                                Text("Enter the 6-digit decryption code sent to your phone:")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                                
                                GlassTextField(placeholder: "OTP Decryption Code", icon: "key.fill", text: $otpInput)
                                
                                BreathingButton(title: "Verify & Decrypt", icon: "checkmark.shield.fill", isGlowing: true) {
                                    appViewModel.completeAuth()
                                }
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showOTPStage = false
                                    }
                                }) {
                                    Text("Resend Code")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                                }
                            }
                            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Social Apple & Google Authentication
                VStack(spacing: 12) {
                    Text("OR CONNECT VIA")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                    
                    HStack(spacing: 16) {
                        // Apple Sign In
                        Button(action: {
                            SoundManager.shared.playClick()
                            appViewModel.completeAuth()
                        }) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.title3)
                                Text("Apple Secure")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        }
                        
                        // Google Sign In
                        Button(action: {
                            SoundManager.shared.playClick()
                            appViewModel.completeAuth()
                        }) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .font(.title3)
                                Text("Google Cloud")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.12), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 25)
                .padding(.bottom, 30)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
                animateFields = true
            }
        }
    }
}

// Custom Glass Text Field with beautiful glowing stroke
struct GlassTextField: View {
    var placeholder: String
    var icon: String
    @Binding var text: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 24)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                TextField("", text: $text)
                    .foregroundColor(themeManager.currentTheme.primaryText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .font(.system(.subheadline, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    text.isEmpty ? Color.white.opacity(0.08) : themeManager.currentTheme.primaryAccent.opacity(0.4),
                    lineWidth: 1
                )
        )
    }
}

struct GlassSecureField: View {
    var placeholder: String
    var icon: String
    @Binding var text: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 24)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                }
                SecureField("", text: $text)
                    .foregroundColor(themeManager.currentTheme.primaryText)
            }
            .font(.system(.subheadline, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    text.isEmpty ? Color.white.opacity(0.08) : themeManager.currentTheme.primaryAccent.opacity(0.4),
                    lineWidth: 1
                )
        )
    }
}
