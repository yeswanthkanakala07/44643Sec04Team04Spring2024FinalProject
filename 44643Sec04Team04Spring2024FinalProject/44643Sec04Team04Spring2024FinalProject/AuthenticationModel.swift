
import FirebaseAuth
import Firebase
import GoogleSignIn
import GoogleSignInSwift


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws{
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    
    func signIn(email: String, password: String) async throws{
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func resetPassword(email :String) async throws{
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Password reset email sent successfully.")
        } catch {
            print("Error sending password reset email: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteUser(){
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Error while trying to delete user - \(error.localizedDescription)")
            } else {
                print("Success! User deleted.")
            }
        }
    }
    
    
    enum AuthenticationError : Error{
        case tokenError(message: String)
    }
    
    func signInwithGoogle() async->Bool{
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            fatalError("NO client Id found in Firebase")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootviewcontroller = await window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        do{
            let userAuthentication =  try await GIDSignIn.sharedInstance.signIn(withPresenting: rootviewcontroller)
            let user = userAuthentication.user
            
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "Id token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
            
        }
        catch{
            print(error.localizedDescription)
            return false
        }
    }
   
}


