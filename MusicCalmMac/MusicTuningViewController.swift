//
//  MusicTuningViewController.swift
//  MusicCalm
//
//  Created by Nithya Appannagaari on 12/3/22.
//

import UIKit

public var genreInd = 2

class MusicTuningViewController: UIViewController {
    
    
    /*
     display genres as artist
     * SZA (R&B)
     * Queen (rock/metal)
     * Symphonies (classical)
     * Adele (pop)
     * Kendrick Lamar (hip hop)
     
     */
    
    var pauseCount = 0
    
    @IBOutlet weak var tuningHeartBeat: UIBarButtonItem!
    
    /*
    @IBOutlet weak var PopButton: UIButton!
    @IBOutlet weak var HipHopButton: UIButton!
    @IBOutlet weak var ClassicalButton: UIButton!
    @IBOutlet weak var RNBButton: UIButton!
    @IBOutlet weak var RockButton: UIButton!
    */
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
      //  self.setHeartBeat()
    //    self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
         //   self.setHeartBeat()
          //  })

        // Do any additional setup after loading the view.
    }
    
    override func loadView()
    {
        super.loadView()
        self.setHeartBeat()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                   self.setHeartBeat()
               }
    }
    
    @IBAction func popButtonPressed(_ sender: Any) {
        genreInd = 3
    }
    @IBAction func hipHopButtonPressed(_ sender: Any) {
        genreInd = 4
    }
    @IBAction func classicalButtonPressed(_ sender: Any) {
        genreInd = 2
    }
    @IBAction func rnbButtonPressed(_ sender: Any) {
        genreInd = 0
    }
    @IBAction func rockButtonPressed(_ sender: Any) {
        genreInd = 1
    }
    
    func setHeartBeat()
    {
       // heartBeat.title = String(heartBeatNum)
        
        print("setting heart beat")
        
        if(heartBeatNums != nil && !heartBeatNums.isEmpty)
        {
            let num = heartBeatNums[heartCount]
            
            tuningHeartBeat?.title = String(num)
            
            print("title is \(num)")
            
            /*if(num < 90) {
                state = HeartState.normal
            }
            
            else if(num >= 110 && num < 120)
            {
                state = HeartState.stressed
            }
            
            else if(num >= 130)
            {
                state = HeartState.anxious
            }*/
            
           // heartCount+=1
            
            if(heartCount >= 199){
                timer.invalidate()
            }
        }
    }
    
    // create method that returns the current heartbeat
    
/*    func setHeartBeat()
    {
        tuningHeartBeat.title = String(heartBeatNum)
        
        if(heartBeatNum < 90) {
            state = HeartState.normal
        }
        
        else if(heartBeatNum >= 90 && heartBeatNum < 120)
        {
            state = HeartState.stressed
        }
        
        else
        {
            state = HeartState.anxious
        }
    }*/
    
    // create method that returns the current heartbeat
    
    @IBAction func openInsta(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/music.calm2023/")! as URL, options: [:], completionHandler: nil)
    }
    @available(iOS 13.0, *)
    @IBAction func pauseOrPlay(_ sender: UIBarButtonItem) {
        pauseCount+=1
        
        if(pauseCount%2 == 1)
        {
            sender.image = UIImage(systemName: "play.circle")
            player?.pause()
        }
        
        else
        {
            sender.image = UIImage(systemName: "pause.circle")
            player?.play()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
