import Foundation

class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    // Replace with your real Supabase dashboard URL and anon key
    var supabaseURL: String = "https://ueuwvzxicotfflipntfx.supabase.co"
    var supabaseAnonKey: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVldXd2enhpY290ZmZsaXBudGZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA2NDI3MDUsImV4cCI6MjA5NjIxODcwNX0.pQh_bDRqC3Ku3lWMqndk7AhZL5r6sr435D4ox6FeVeI"
    
    var isConfigured: Bool {
        return !supabaseURL.contains("your-project-ref") && !supabaseAnonKey.contains("your-anon-public-key")
    }
    
    // Perform standard GET requests
    func fetchTable<T: Decodable>(tableName: String, jwtToken: String? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        guard isConfigured, let url = URL(string: "\(supabaseURL)/rest/v1/\(tableName)") else {
            completion(.failure(NSError(domain: "Supabase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Client not configured"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = jwtToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Supabase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Handle standard SQL dates
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let result = try decoder.decode([T].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Perform standard POST requests
    func insertRow<T: Encodable, R: Decodable>(tableName: String, row: T, jwtToken: String? = nil, completion: @escaping (Result<[R], Error>) -> Void) {
        guard isConfigured, let url = URL(string: "\(supabaseURL)/rest/v1/\(tableName)") else {
            completion(.failure(NSError(domain: "Supabase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Client not configured"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(jwtToken ?? supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer") // Returns inserted row
        
        do {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            request.httpBody = try encoder.encode(row)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Supabase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Empty payload returned"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([R].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
