import Foundation

class ApisViewModel {
    
    static let shared = ApisViewModel()
    
    var videos: [Video] = []
    
    func fetchVideos(completion: @escaping ([Video]) -> Void) {
        guard let url = URL(string: "https://demo8774027.mockable.io/getVideos") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching videos: \(error)")
                completion([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion([])
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let videoResponse = try decoder.decode(VideoResponse.self, from: data)
                    self.videos = videoResponse.videos
                    completion(videoResponse.videos)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion([])
                }
            } else {
                print("No data received")
                completion([])
            }
        }.resume()
    }

}



struct VideoResponse: Decodable {
    let videos: [Video]
}


struct Video: Decodable {
    let title: String
    let videoUrl: String
}
