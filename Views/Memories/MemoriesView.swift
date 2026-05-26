import SwiftUI

struct MemoriesView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isPostingMemory = false
    @State private var newMemoryTitle = ""
    @State private var newMemoryCaption = ""
    @State private var animateStoryTimeline = false
    
    var body: some View {
        ZStack {
            // Soft scrolling memories list
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    // Header Area
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PARALLEL TIMELINES")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            Text("Trip Memories")
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        // Action: Add new memory node
                        Button(action: {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                                isPostingMemory = true
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(themeManager.currentTheme.accentGradient)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 8)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Emotional AI recap banner (Vision Pro Style Glass)
                    GlassCard(cornerRadius: 22, fillOpacity: 0.1, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Label("AI MEMORY ASSISTANT", systemImage: "sparkles")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.primaryAccent)
                                Spacer()
                            }
                            
                            Text("Shibuya's neon was energetic, but the parallel highlights reveal that the group felt most connected in the hidden, quiet sub-basement alleys.")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineSpacing(4)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Parallel Perspective Switcher Header
                    Text("Parallel Moments Feed")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .padding(.horizontal, 20)
                    
                    // Memories timeline list
                    VStack(spacing: 24) {
                        ForEach(appViewModel.memories) { memory in
                            MemoryCard(memory: memory)
                                .opacity(animateStoryTimeline ? 1.0 : 0.0)
                                .offset(y: animateStoryTimeline ? 0 : 30)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 120)
                }
            }
            
            // Post New Memory Drawer Sheet (Glassmorphic popover)
            if isPostingMemory {
                ZStack {
                    // Dim Backdrop
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isPostingMemory = false
                            }
                        }
                    
                    // Input Card
                    VStack {
                        Spacer()
                        
                        GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.secondaryAccent) {
                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    Text("Share Spontaneous Moment")
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isPostingMemory = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                }
                                
                                GlassTextField(placeholder: "Moment Title", icon: "pencil", text: $newMemoryTitle)
                                
                                GlassTextField(placeholder: "What's the crew doing?", icon: "doc.text.fill", text: $newMemoryCaption)
                                
                                BreathingButton(title: "Broadcast to Parallel Timeline", icon: "sparkles", isGlowing: true) {
                                    if !newMemoryTitle.isEmpty && !newMemoryCaption.isEmpty {
                                        let randomColors = [
                                            [Color(hex: "ff007f"), Color(hex: "7000ff")],
                                            [Color(hex: "00f5d4"), Color(hex: "3a86ff")],
                                            [Color(hex: "fb8500"), Color(hex: "ffb703")]
                                        ].randomElement()!
                                        
                                        appViewModel.postNewMemory(
                                            title: newMemoryTitle,
                                            caption: newMemoryCaption,
                                            accentColors: randomColors
                                        )
                                        
                                        newMemoryTitle = ""
                                        newMemoryCaption = ""
                                        withAnimation(.spring()) {
                                            isPostingMemory = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.76)) {
                animateStoryTimeline = true
            }
        }
    }
}
