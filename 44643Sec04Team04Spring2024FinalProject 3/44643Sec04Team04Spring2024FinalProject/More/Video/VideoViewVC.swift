 
import UIKit

var selectedVideo = ""


class VideoViewVC: UIViewController {

   
    @IBOutlet weak var player: YouTubePlayerView!
    
    
    override func viewDidLoad() {
        
        let myVideoURL = URL(string: selectedVideo)
        player.loadVideoURL(myVideoURL! as URL)
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.player.play()
        })
    }
}
