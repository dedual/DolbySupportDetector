//
//  ModalPlayerViewController.swift
//  Dolby Swift Sampler
//
//  Created by Nicolas Dedual on 9/4/16.
//  Copyright © 2016 DeEnt. All rights reserved.
//

import UIKit
import AVFoundation

class ModalPlayerViewController: UIViewController {
    
    var playerLayer: AVPlayerLayer?
    var filename:String!    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let videoURL: NSURL = Bundle.main.url(forResource: filename, withExtension: "FILEFORMATGOESHERE")! as NSURL
        let player = AVPlayer(url: videoURL as URL)
       
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = self.view!.bounds
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect

        
        self.view!.layer.addSublayer(playerLayer!)
        
        player.play()
        
        let duration = player.currentItem!.duration
        
        NotificationCenter.default.addObserver(self, selector: #selector(ModalPlayerViewController.playerDidFinishPlaying(note:)),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        
        let timeObserver = player.addBoundaryTimeObserver(forTimes: [NSValue(time: duration)], queue: nil) {[weak self] in
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }

    func playerDidFinishPlaying(note: NSNotification) {
            print("Video Finished")
            self.playerLayer!.removeFromSuperlayer()
        
            self.dismiss(animated: true, completion: {
            
        })
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
    {
        playerLayer!.frame = self.view!.bounds
        self.view.setNeedsLayout()
        playerLayer!.setNeedsLayout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
