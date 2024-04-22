
import FirebaseFirestoreSwift
import Photos

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseAuth
 
struct Photo {
    var image: UIImage
    var downloadURL: URL?
}
  
class FireStoreManager {
    
    public static let shared = FireStoreManager()
    var hospital = [String]()
    
    var db: Firestore!
    var usersDB : CollectionReference!
    var teamsDb : CollectionReference!
    var tournamentPlayers : CollectionReference!
    var matches : CollectionReference!
    var matchesRecords : CollectionReference!
    
    var storageRef: StorageReference!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        usersDB = db.collection("Users")
        teamsDb = db.collection("Teams")
        tournamentPlayers = db.collection("TournamentPlayers")
        matches = db.collection("Matches")
        matchesRecords = db.collection("MatchesRecords")
        storageRef = Storage.storage().reference()
    }
    
     
    
    func getTournamentTeams(tournamentId:String,completion: @escaping ([TeamList]) -> Void) {
        
        self.getQueryFromFirestore(collectionPath: "Teams", field:  "tournamentId", compareValue: tournamentId) { snapshot in
             
            var data = [TeamList]()
            
            for document in snapshot.documents {
                do {
                    var temp = try document.data(as: TeamList.self)
                    temp.documentId = document.documentID
                    data.append(temp)
                } catch let error {
                    print(error)
                }
            }
            completion(data)
            
        }
      
    } 
    
    
    func getRecords(playerId:String,completion: @escaping ([PlayerData]) -> Void) {
        
        self.getQueryFromFirestore(collectionPath: "MatchesRecords", field:  "playerId", compareValue: playerId) { snapshot in
             
            var data = [PlayerData]()
            
            for document in snapshot.documents {
                do {
                    var temp = try document.data(as: PlayerData.self)
                    data.append(temp)
                } catch let error {
                    print(error)
                }
            }
            completion(data)
            
        }
      
    }
    
    
    func getTournamentMatches(tournamentId:String,completion: @escaping ([Match]) -> Void) {
        
        self.getQueryFromFirestore(collectionPath: "Matches", field:  "tournamentId", compareValue: tournamentId) { snapshot in
             
            var data = [Match]()
            
            for document in snapshot.documents {
                do {
                    var temp = try document.data(as: Match.self)
                    temp.documentId = document.documentID
                    data.append(temp)
                } catch let error {
                    print(error)
                }
            }
            completion(data)
            
        }
      
    } 
    
    
    func saveORUpdatePlayerRecord(playerId: String, tournamentId: String, teamId: String, playerName: String, runs: Int, balls: Int, fours: Int, sixes: Int, haveFifty: Bool, haveHundred: Bool, completion: @escaping (Bool, String?) -> Void) {
        
        let data: [String: Any] = [
            "tournamentId": tournamentId,
            "teamId": teamId,
            "playerId": playerId,
            "name": playerName,
            "runs": runs,
            "balls": balls,
            "fours": fours,
            "sixes": sixes,
            "haveFifty": haveFifty,
            "haveHundred": haveHundred
        ]

        self.matchesRecords.addDocument(data: data) { error in
            if let error = error {
                completion(false, "Error adding player record: \(error.localizedDescription)")
            } else {
                completion(true, "Player record added successfully")
            }
        }
    }

 

    
    func getAllTournamentMatches(completion: @escaping ([Match]) -> Void) {
        
        
        matches.getDocuments { snapshot, err in
             
            
            var data = [Match]()
            
            if let snapshot = snapshot  {
                
                for document in snapshot.documents {
                    do {
                        var temp = try document.data(as: Match.self)
                        temp.documentId = document.documentID
                        data.append(temp)
                    } catch let error {
                        print(error)
                    }
                }
                
            }
           
            completion(data)
        }
        
         
      
    }
    
    func getTournamentPlayers(completion: @escaping ([TournamentPlayers]) -> Void) {
        
    
        self.getQueryFromFirestore(collectionPath: "TournamentPlayers", field:  "playerId", compareValue: DataSaver.shared.getUID()) { snapshot in
             
            var data = [TournamentPlayers]()
            
            for document in snapshot.documents {
                do {
                    var temp = try document.data(as: TournamentPlayers.self)
                    temp.documentId = document.documentID
                    data.append(temp)
                } catch let error {
                    print(error)
                }
            }
            completion(data)
            
        }
        
      
    }
    
    
    func getAllTournamentPlayers(completion: @escaping ([TournamentPlayers]) -> Void) {
        
        tournamentPlayers.getDocuments { snapshot, err in
             
            
            var data = [TournamentPlayers]()
            
            if let snapshot = snapshot  {
                
                for document in snapshot.documents {
                    do {
                        var temp = try document.data(as: TournamentPlayers.self)
                        temp.documentId = document.documentID
                        data.append(temp)
                    } catch let error {
                        print(error)
                    }
                }
                
            }
           
            completion(data)
        }
        
      
    }
    
     
    
    
        
    func getTournamentTeamsPlayer(tournamentId: String, teamId: String, completion: @escaping ([PlayerList]) -> Void) {
        tournamentPlayers
            .whereField("tournamentId", isEqualTo: tournamentId)
            .whereField("teamId", isEqualTo: teamId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting tournament players: \(error)")
                    completion([])
                    return
                }
                
                var data = [PlayerList]()
                
                
                for document in snapshot?.documents ?? [] {
                    do {
                        var temp = try document.data(as: PlayerList.self)
                        temp.documentId = document.documentID
                        data.append(temp)
                    } catch let error {
                        print(error)
                    }
                }
                completion(data)
            }
    }

    
    
    func deleteData(path:String, doucumentId:String,completion: @escaping (Bool)->() ) {
        
        db.collection(path).document(doucumentId).delete { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    
    func deleteTeam( doucumentId:String,completion: @escaping (Bool)->() ) {
        
        let db = db.collection("Teams")
        
        db.document(doucumentId).delete { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    
     func deleteMatch( doucumentId:String,completion: @escaping (Bool)->() ) {
        
        let db = db.collection("Matches")
        
        db.document(doucumentId).delete { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    
  
    
   
}

extension FireStoreManager {
    
    
    
    func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
        let dbr = db.collection("Users")
        dbr.addDocument(data: data) { err in
            if let err = err {
                showAlerOnTop(message: "Error adding document: \(err)")
            } else {
                completionHandler("success")
            }
        }
        
        
    }
    
    
    
    func getQueryFromFirestore(collectionPath:String,field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
        
        db.collection(collectionPath).whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
            
            if let err = err {
                
                showAlerOnTop(message: "Error getting documents: \(err)")
                return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    showAlerOnTop(message: "Something went wrong!!")
                }
                
            }
        }
        
    }
    
}


extension FireStoreManager {
    
   
    
    func createMatch(tournamentId: String, team1Id: String, team2Id: String, matchName: String, logo1: String, logo2: String, completion: @escaping (Bool, String?) -> Void) {
        let matchData: [String: Any] = [
            "tournamentId": tournamentId,
            "team1Id": team1Id,
            "team2Id": team2Id,
            "matchName": matchName,
            "logo1": logo1,
            "logo2": logo2
        ]

        // Add the match data to Firestore
        matches.addDocument(data: matchData) { error in
            if let error = error {
                // If there's an error, return false and the error message
                completion(false, "Error creating match: \(error.localizedDescription)")
            } else {
                // If successful, return true and a success message
                completion(true, "Match created successfully")
            }
        }
    }

      
    
    func createTeam(tournamentId: String, teamName: String, logoImage: UIImage, completion: @escaping (Bool, String?) -> Void) {
        
        FireStoreManager.shared.saveImage(imgName: Date().description, image: logoImage) { imageUrl in
            
            
            let data: [String: Any] = [
                "teamName": teamName,
                "logoImage": imageUrl,
                "tournamentId": tournamentId
            ]
            
            self.teamsDb.addDocument(data: data){ err in
                
                if let err = err {
                    
                    completion(false, "Error adding product ")
                } else {
                    
                    completion(true, "Team added successfully ")
                    
                }
                
            }
            
        }
    }
    

    
    func joinTeam(tournamentId: String, teamName: String, logoImage: String, teamId: String, playerName: String, playerId: String, completion: @escaping (Bool, String?) -> Void) {

        // First, check if the player already exists
        let playerQuery = tournamentPlayers.whereField("tournamentId", isEqualTo: tournamentId).whereField("playerId", isEqualTo: playerId)

        
       
        
        playerQuery.getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, "Error checking player existence: \(error.localizedDescription)")
                return
            }

            // If playerId already exists, return with an error
            if !snapshot!.isEmpty {
                completion(false, "Player already exists")
                return
            }

            // If playerId doesn't exist, proceed to add the player
            let data: [String: Any] = [
                "teamName": teamName,
                "logoImage": logoImage,
                "tournamentId": tournamentId,
                "teamId": teamId,
                "name": playerName,
                "playerId": playerId
            ]

            self.tournamentPlayers.addDocument(data: data) { error in
                if let error = error {
                    completion(false, "Error adding player: \(error.localizedDescription)")
                } else {
                    completion(true, "Player added successfully")
                }
            }
        }
    }


    
    
    func saveImage(imgName:String,image: UIImage,completion: @escaping (String)->()) {
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child("images/\(imgName)")
            
            let _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
               
                if let error = error {
                    print(error)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let _ = error {
                            completion("")
                        } else {
                            print(url!.path)
                            print(url!.description)
                            completion(url!.description)
                        }
                    }
                }
            }
        }
    }
    
    
   
   
    
}


struct TeamList :Codable,Hashable {
  let tournamentId:String
  let teamName:String
  let logoImage:String
  var documentId :String?
}



struct PlayerList :Codable {
  let tournamentId:String
  let name:String
  var playerId :String?
  var teamId:String
  var teamName:String
  var documentId :String?
}
 

struct Match: Codable {
    let tournamentId: String
    let team1Id: String
    let team2Id: String
    let matchName: String
    let logo1: String
    let logo2: String
    var documentId:String?
}



struct TournamentPlayers: Codable {
    let logoImage: String?
    let name: String?
    let playerId: String?
    let teamId: String?
    let teamName: String?
    let tournamentId: String?
    var documentId: String?
}


struct PlayerData :Codable {
    let balls: Int
    let fours: Int
    let haveFifty: Bool
    let haveHundred: Bool
    let name: String
    let playerId: String
    let runs: Int
    let sixes: Int
    let teamId: String
    let tournamentId: String
}
