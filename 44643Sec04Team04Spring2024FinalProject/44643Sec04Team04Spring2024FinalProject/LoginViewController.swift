//
//  ViewController.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 2/19/24.
//

import UIKit
import Lottie
import AnimatedGradientView
class LoginViewController: UIViewController {

    @IBOutlet weak var LaunchLAV:LottieAnimationView!{
    
    didSet{
        LaunchLAV.loopMode = .playOnce
        LaunchLAV.animationSpeed = 1.0
        LaunchLAV.play { [weak self] _ in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0.0,
                options:[.curveEaseInOut]){
                    self?.LaunchLAV.alpha = 0.0
                }
        }
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let animationgradveiw = AnimatedGradientView()
                animationgradveiw .autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
                animationgradveiw .animationValues = [
                    (colors: ["#2BC0E6", "#EAECC6"], .up, .axial),
                    
                    (colors: ["#e876bb", "#E5E5BE"], .down, .axial),
                    
                ]
                animationgradveiw .direction = .down
                animationgradveiw .frame = view.bounds
                animationgradveiw.isUserInteractionEnabled = false
                view.insertSubview( animationgradveiw, at : 0)        // Do any additional setup after loading the view.
    }


}

