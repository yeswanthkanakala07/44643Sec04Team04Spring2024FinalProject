
import Foundation
import UIKit
import Firebase

struct Tournament: Codable {
    var name: String?
    var city: String?
    var ground: String?
    var organizerName: String?
    var organizerPhone: String?
    var startDate: Timestamp
    var endDate: Timestamp
    var ballType: String
    var pitchType: String
    var matchType: String
    var otherDetails: String?
    var logo: String?
    var teams: [String]?

    
}





