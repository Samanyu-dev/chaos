import Foundation
import AuthenticationServices
import CryptoKit

class AuthManager: NSObject, ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var activeToken: String? = nil
    
    private let tokenKeychainAccount = "social.chaos.orbit.jwtToken"
    private var currentNonce: String?
    
    override init() {
        super.init()
        // Check Keychain for pre-existing session token
        if let token = KeychainHelper.shared.getToken(account: tokenKeychainAccount) {
            self.activeToken = token
            self.isAuthenticated = true
        }
    }
    
    // Apple's recommended cryptographically random nonce generation
    func generateRandomNonce() -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._~")
        var result = ""
        var remainingLength = 32
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in UInt8.random(in: 0...255) }
            for random in randoms {
                if remainingLength == 0 { break }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func startAppleSignInFlow() -> ASAuthorizationAppleIDRequest {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = generateRandomNonce()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        return request
    }
    
    func handleAuthorization(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let identityToken = appleIDCredential.identityToken,
                  let tokenString = String(data: identityToken, encoding: .utf8) else {
                print("Failed to serialize Apple ID Credentials.")
                return
            }
            
            // Successfully signed in
            DispatchQueue.main.async {
                self.activeToken = tokenString
                self.isAuthenticated = true
                KeychainHelper.shared.saveToken(token: tokenString, account: self.tokenKeychainAccount)
                SoundManager.shared.playSuccess()
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.activeToken = nil
            KeychainHelper.shared.deleteToken(account: self.tokenKeychainAccount)
            SoundManager.shared.playTransition()
        }
    }
}
