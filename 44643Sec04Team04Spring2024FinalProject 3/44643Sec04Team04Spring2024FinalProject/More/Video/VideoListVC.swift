import UIKit

class VideoListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
            
        self.tableView.tableFooterView = UIView()
        
        self.fetchVideos()
       
    }
    
    
  
    
    func fetchVideos() {
       
        ApisViewModel.shared.fetchVideos { videos in
            
        
            print("Fetched videos: \(videos)")
            self.videos = videos
          
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

       
    }
    
    
}

extension VideoListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return videos.count
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = videos[indexPath.row].videoUrl
        performSegue(withIdentifier: "Video", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
            
        
        
         let videoEmoji = "📹"
         cell.textLabel?.text = "\(videoEmoji) \(self.videos[indexPath.row].title)"
 
       
          return cell
          
        }
        
      
    }

    
 
