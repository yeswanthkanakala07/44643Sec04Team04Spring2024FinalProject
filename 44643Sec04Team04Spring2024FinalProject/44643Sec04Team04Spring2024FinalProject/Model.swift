//
//  Model.swift
//  Shopcy
//
//  Created by Sai Dinesh Kopparthi on 2/5/24.
//

import Foundation
import Firebase


struct Product: Codable{
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let thumbnail: String
    let images:[String]
    var cartCount: Int
}

enum ProductKeys: String, CaseIterable{
    case shopcy_product_1
    case shopcy_product_2
    case shopcy_product_3
    case shopcy_product_4
    case shopcy_product_5
    case shopcy_product_6
    case shopcy_product_7
    case shopcy_product_8
}



struct FireStoreOperations{
    
    static let db = Firestore.firestore()
    static var products: [String : Product] = [:]
    
    public static func fetchProducts() async{
        
        for key in ProductKeys.allCases {
            let docRef = db.collection("Products").document(key.rawValue)
            do{
                let document = try await docRef.getDocument()
                if document.exists {
                    let productData = document.data()
                    
                    let title = productData?["title"] as? String ?? "N/A"
                    let description = productData?["description"] as? String ?? "N/A"
                    let price = productData?["price"] as? Double ?? 0
                    let discountPercentage = productData?["discountPercentage"] as? Double ?? 0
                    let rating = productData?["rating"] as? Double ?? 0
                    let thumbnail = productData?["thumbnail"] as? String ?? "N/A"
                    let images:[String] = productData?["images"] as? [String] ?? []
                    let cartCount = productData?["cartCount"] as? Int ?? 0
                    
                    let product = Product(title: title, description: description, price: price, discountPercentage: discountPercentage, rating: rating, thumbnail: thumbnail, images: images, cartCount: cartCount)
                    products[key.rawValue] = product
                } else{
                    print("Document does not exist")
                }
            } catch {
                print("Error getting document: \(error)")
            }
        }
    }
    
    public static func updateProduct(_ key: String) async{
        let product = products[key]!
        do {
            try await db.collection("Products").document(key).updateData([
                "cartCount" : product.cartCount
            ])
        } catch {
            print("Error updating cart count: \(error)")
        }
    }
}
