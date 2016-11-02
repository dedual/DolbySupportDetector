//
//  ViewController.swift
//  Dolby Swift Sampler
//
//  Created by Nicolas Dedual on 8/28/16.
//  Copyright © 2016 DeEnt. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet var playMovieDolby:UIButton!
    @IBOutlet var playMovieRegular:UIButton!
    
    let regularMovieFilename = "NORMALLYENCODEDMOVIEFILENAME"
    let dolbyMovieFilename = "DOLBYENCODEDMOVIEFILENAME"
    
    var ddpDecoderIsAvailable:Bool // variable used to determine whether Dolby Digital Plus is supported by the device
    {
        get{
            var ddpSpecifier:UInt32 = kAudioFormatEnhancedAC3 // codec in particular we want to test
            var size:UInt32 = 0
            
            let errorPropertyInfo = AudioFormatGetPropertyInfo(kAudioFormatProperty_Decoders, UInt32(MemoryLayout.size(ofValue: ddpSpecifier)), &ddpSpecifier, &size) // checks to ensure we have info on the desired decoder
            
            guard errorPropertyInfo == 0 else {
                print("Error getting Dolby DDP audio format property (code: \(errorPropertyInfo)")
                return false
            }
            
            var numDecoders = Int(size) / MemoryLayout<AudioClassDescription>.size
            
            var decoderDescriptions:[AudioClassDescription] = Array(repeating: AudioClassDescription(), count: numDecoders)
            
            let errorProperty = AudioFormatGetProperty(kAudioFormatProperty_Decoders, UInt32(MemoryLayout.size(ofValue: ddpSpecifier)), &ddpSpecifier, &size, &decoderDescriptions); // checks that we have the actual decoder
            
            if (errorProperty != 0) {
                print("Error getting installed Dolby DDP decoder (code: \(errorProperty)");
                return false;
            }
            
            #if DEBUG
            
                for i in 0..<numDecoders
                {
                    let type = FourCharCode(decoderDescriptions[i].mType).possibleFourCharString
                    let subType = FourCharCode(decoderDescriptions[i].mSubType).possibleFourCharString
                    let manufacturer = FourCharCode(decoderDescriptions[i].mManufacturer).possibleFourCharString
                    
                    print("Decoder type: \(type) subtype: \(subType) manufacturer: \(manufacturer)")
                }
                
            #endif
            
            return true
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playMovieDolby.isEnabled = ddpDecoderIsAvailable
        
    }
    
    @IBAction func dolbyPressed(sender:UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailViewController: ModalPlayerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ModalPlayerViewController")  as? ModalPlayerViewController {
            detailViewController.modalPresentationStyle = .fullScreen
            
            detailViewController.filename = dolbyMovieFilename
            
            self.present(detailViewController, animated: true, completion: { () -> Void in
                // do stuff!
            })
        }
        
    }
    
    @IBAction func regularPlay(sender:UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailViewController: ModalPlayerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ModalPlayerViewController")  as? ModalPlayerViewController {
            detailViewController.modalPresentationStyle = .fullScreen
            
            detailViewController.filename = regularMovieFilename
            
            self.present(detailViewController, animated: true, completion: { () -> Void in
                // do stuff!
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

