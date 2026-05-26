import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isAddingExpense = false
    @State private var expenseTitle = ""
    @State private var expenseAmount = ""
    
    @State private var selectedCategory = "General"
    @State private var animateCharts = false
    
    let categories = ["General", "Nightlife", "Memories", "Entertainment"]
    
    var body: some View {
        ZStack {
            // Scrollable Expense Board
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    // Header Area
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SPLIT EXPENSES")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            Text("Shared Ledger")
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        // Action: Add new expense
                        Button(action: {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
                                isAddingExpense = true
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
                    
                    // Spending Analytics Glass Chart (procedural custom charts)
                    GlassCard(cornerRadius: 24, fillOpacity: 0.1, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Trip Spending Breakdown")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(themeManager.currentTheme.primaryAccent)
                            
                            HStack(alignment: .bottom, spacing: 18) {
                                ForEach(0..<4) { index in
                                    let heights: [CGFloat] = [70, 140, 95, 120]
                                    let labels = ["Food", "Clubs", "Films", "Quads"]
                                    let height = heights[index]
                                    
                                    VStack(spacing: 8) {
                                        Spacer()
                                        // Neon dynamic pillar
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        themeManager.currentTheme.primaryAccent,
                                                        themeManager.currentTheme.secondaryAccent.opacity(0.6)
                                                    ],
                                                    startPoint: .top, endPoint: .bottom
                                                )
                                            )
                                            .frame(height: animateCharts ? height : 0)
                                            .frame(width: 32)
                                            .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.4), radius: 6, y: -2)
                                        
                                        Text(labels[index])
                                            .font(.system(size: 9, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(height: 160)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Fairness Balance Summary Row
                    Text("Fairness Split Balances")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(appViewModel.friends) { friend in
                                BalanceBubbleNode(friend: friend, amount: Double.random(in: -80...120))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Activity list feed
                    Text("Split Payment Activity")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryAccent)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(appViewModel.expenses) { expense in
                            ExpenseCard(expense: expense)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 120)
                }
            }
            
            // Log New Expense popover drawer
            if isAddingExpense {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isAddingExpense = false
                            }
                        }
                    
                    VStack {
                        Spacer()
                        
                        GlassCard(cornerRadius: 28, fillOpacity: 0.18, hasGlow: true, glowColor: themeManager.currentTheme.primaryAccent) {
                            VStack(alignment: .leading, spacing: 18) {
                                HStack {
                                    Text("Log New Expense")
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isAddingExpense = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                }
                                
                                GlassTextField(placeholder: "Expense Title (e.g. Ramen)", icon: "cart.fill", text: $expenseTitle)
                                
                                GlassTextField(placeholder: "Amount ($0.00)", icon: "dollarsign.circle.fill", text: $expenseAmount)
                                    .keyboardType(.decimalPad)
                                
                                // Category Selector
                                Text("Select Category:")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(themeManager.currentTheme.secondaryText)
                                
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.self) { cat in
                                        Button(action: {
                                            selectedCategory = cat
                                        }) {
                                            Text(cat)
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(selectedCategory == cat ? .white : themeManager.currentTheme.secondaryText)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(selectedCategory == cat ? themeManager.currentTheme.primaryAccent : .white.opacity(0.06))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                
                                BreathingButton(title: "Commit Split Bill", icon: "creditcard.fill", isGlowing: true) {
                                    if let amt = Double(expenseAmount), !expenseTitle.isEmpty {
                                        // Auto splits Alex + 2 friends
                                        let involved = [appViewModel.currentUser, appViewModel.friends[0], appViewModel.friends[1]]
                                        
                                        appViewModel.addExpense(
                                            title: expenseTitle,
                                            amount: amt,
                                            payer: appViewModel.currentUser,
                                            splitUsers: involved
                                        )
                                        
                                        expenseTitle = ""
                                        expenseAmount = ""
                                        withAnimation(.spring()) {
                                            isAddingExpense = false
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
            withAnimation(.spring(response: 0.75, dampingFraction: 0.72)) {
                animateCharts = true
            }
        }
    }
}

// Custom balance bubble indicating who owes what
struct BalanceBubbleNode: View {
    var friend: User
    var amount: Double
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GlassCard(cornerRadius: 16, fillOpacity: 0.08) {
            VStack(spacing: 8) {
                Text(friend.avatar)
                    .font(.title2)
                
                Text(friend.name.split(separator: " ").first ?? "")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // Color balances: positive (green/teal), negative (red/pink)
                let isOwed = amount > 0
                Text(isOwed ? "+$" + String(format: "%.2f", amount) : "-$" + String(format: "%.2f", abs(amount)))
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(isOwed ? Color(hex: "00f5d4") : Color(hex: "ff006e"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(isOwed ? Color(hex: "00f5d4").opacity(0.12) : Color(hex: "ff006e").opacity(0.12))
                    .cornerRadius(6)
            }
            .frame(width: 80)
        }
    }
}
