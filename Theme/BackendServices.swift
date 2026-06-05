import Foundation
import SwiftUI

// DB-compatible mapping entities for memories
struct DBMemory: Codable {
    var id: UUID?
    var trip_id: UUID
    var title: String
    var sender_name: String
    var sender_avatar: String
    var caption: String
    var relative_time: String
    var likes: Int
    var perspective_name: String
    var gradient_colors: [String]
    var image_url: String?
    var lat_offset: Double
    var lon_offset: Double
    
    // Convert DB entity to frontend Memory model
    func toModel() -> Memory {
        Memory(
            id: id ?? UUID(),
            tripId: trip_id,
            title: title,
            senderName: sender_name,
            senderAvatar: sender_avatar,
            caption: caption,
            relativeTime: relative_time,
            likes: likes,
            perspectiveName: perspective_name,
            gradientColors: gradient_colors.map { Color(hex: $0) },
            imageURL: image_url,
            latOffset: lat_offset,
            lonOffset: lon_offset
        )
    }
}

// DB-compatible mapping entities for expenses
struct DBExpense: Codable {
    var id: UUID?
    var trip_id: UUID
    var title: String
    var amount: Double
    var payer_id: UUID
    var category: String
    var lat_offset: Double
    var lon_offset: Double
    var created_at: Date?
}

// ----------------------------------------------------
// 1. Memory Service
// ----------------------------------------------------
class MemoryService {
    static let shared = MemoryService()
    
    func fetchMemories(jwtToken: String?, completion: @escaping ([Memory]) -> Void) {
        guard SupabaseService.shared.isConfigured else {
            completion(MockData.memories)
            return
        }
        
        SupabaseService.shared.fetchTable(tableName: "memories", jwtToken: jwtToken) { (result: Result<[DBMemory], Error>) in
            switch result {
            case .success(let dbMemories):
                let models = dbMemories.map { $0.toModel() }
                DispatchQueue.main.async { completion(models) }
            case .failure(let error):
                print("Supabase Memories Fetch Error (Falling back to mock): \(error)")
                DispatchQueue.main.async { completion(MockData.memories) }
            }
        }
    }
    
    func uploadMemory(memory: Memory, jwtToken: String?, completion: @escaping (Memory?) -> Void) {
        guard SupabaseService.shared.isConfigured else {
            completion(memory)
            return
        }
        
        let colorsHex = memory.gradientColors.map { color -> String in
            // Extract mock HEX codes
            return "#ff007f"
        }
        
        let dbMemory = DBMemory(
            id: memory.id,
            trip_id: memory.tripId,
            title: memory.title,
            sender_name: memory.senderName,
            sender_avatar: memory.senderAvatar,
            caption: memory.caption,
            relative_time: memory.relativeTime,
            likes: memory.likes,
            perspective_name: memory.perspectiveName,
            gradient_colors: colorsHex,
            image_url: memory.imageURL,
            lat_offset: memory.latOffset,
            lon_offset: memory.lonOffset
        )
        
        SupabaseService.shared.insertRow(tableName: "memories", row: dbMemory, jwtToken: jwtToken) { (result: Result<[DBMemory], Error>) in
            switch result {
            case .success(let inserted):
                if let first = inserted.first {
                    DispatchQueue.main.async { completion(first.toModel()) }
                } else {
                    DispatchQueue.main.async { completion(memory) }
                }
            case .failure(let error):
                print("Supabase Memory Insert Error: \(error)")
                DispatchQueue.main.async { completion(memory) }
            }
        }
    }
}

// ----------------------------------------------------
// 2. Expense Service
// ----------------------------------------------------
class ExpenseService {
    static let shared = ExpenseService()
    
    func fetchExpenses(jwtToken: String?, completion: @escaping ([Expense]) -> Void) {
        guard SupabaseService.shared.isConfigured else {
            completion(MockData.expenses)
            return
        }
        
        SupabaseService.shared.fetchTable(tableName: "expenses", jwtToken: jwtToken) { (result: Result<[DBExpense], Error>) in
            switch result {
            case .success(let dbExpenses):
                let models = dbExpenses.map { dbExp -> Expense in
                    Expense(
                        id: dbExp.id ?? UUID(),
                        tripId: dbExp.trip_id,
                        title: dbExp.title,
                        amount: dbExp.amount,
                        payer: MockData.friends.first(where: { $0.id == dbExp.payer_id }) ?? MockData.me,
                        splits: [], // Splits will be linked via separate split tables or custom API fields
                        category: dbExp.category,
                        timestamp: dbExp.created_at ?? Date(),
                        latOffset: dbExp.lat_offset,
                        lonOffset: dbExp.lon_offset
                    )
                }
                DispatchQueue.main.async { completion(models) }
            case .failure(let error):
                print("Supabase Expenses Fetch Error (Falling back to mock): \(error)")
                DispatchQueue.main.async { completion(MockData.expenses) }
            }
        }
    }
    
    func uploadExpense(expense: Expense, jwtToken: String?, completion: @escaping (Expense?) -> Void) {
        guard SupabaseService.shared.isConfigured else {
            completion(expense)
            return
        }
        
        let dbExpense = DBExpense(
            id: expense.id,
            trip_id: expense.tripId,
            title: expense.title,
            amount: expense.amount,
            payer_id: expense.payer.id,
            category: expense.category,
            lat_offset: expense.latOffset,
            lon_offset: expense.lonOffset,
            created_at: expense.timestamp
        )
        
        SupabaseService.shared.insertRow(tableName: "expenses", row: dbExpense, jwtToken: jwtToken) { (result: Result<[DBExpense], Error>) in
            switch result {
            case .success(let inserted):
                if let _ = inserted.first {
                    DispatchQueue.main.async { completion(expense) }
                } else {
                    DispatchQueue.main.async { completion(expense) }
                }
            case .failure(let error):
                print("Supabase Expense Insert Error: \(error)")
                DispatchQueue.main.async { completion(expense) }
            }
        }
    }
}
