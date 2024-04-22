
import Foundation

class DataSaver  {
   
   static  let shared =  DataSaver()
   
    
   func isLoggedIn() -> Bool{
       
       let email = getEmail()
       
       if(email.isEmpty) {
           return false
       }else {
          return true
       }
     
   }
    
   func getEmail()-> String {
       
       let email = UserDefaults.standard.string(forKey: "email") ?? ""
       
       print(email)
      return email
   }
   
   func getName()-> String {
      return UserDefaults.standard.string(forKey: "name") ?? ""
   }
    
    
  
    
    func removeData(){
        UserDefaults.standard.removeObject(forKey: "email")
        
    }
    
    
    func saveUserData(name:String, email:String,uid:String) {
       UserDefaults.standard.setValue(name, forKey: "name")
       UserDefaults.standard.setValue(email, forKey: "email")
       UserDefaults.standard.setValue(uid, forKey: "uid")
   }
    
    
    func getUID()-> String {
        
        let uid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        print(uid)
       return uid
    }
    
    
   
    
}
