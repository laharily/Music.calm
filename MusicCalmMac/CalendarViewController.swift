//
//  CalendarViewController.swift
//  MusicCalm
//
//  Created by Nithya Appannagaari on 12/3/22.
//

import UIKit
import AVFoundation
import HealthKit

class CalendarViewController: UIViewController {
        
    var pauseCount = 0
   
        
    @IBOutlet weak var calendarHeartBeat: UIBarButtonItem!
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
       //.setHeartBeat()
       
     //   authorizeHealthKit()
      
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
    
   func setHeartBeat()
    {
       // heartBeat.title = String(heartBeatNum)
        
        print("setting heart beat")
        
        if(heartBeatNums != nil && !heartBeatNums.isEmpty)
        {
            let num = heartBeatNums[heartCount]
            
            calendarHeartBeat?.title = String(num)
            
            print("title is \(num)")
            
          /*  if(num < 90) {
                state = HeartState.normal
            }
            
            else if(num >= 110 && num < 120)
            {
                state = HeartState.stressed
            }
            
            else if(num >= 130)
            {
                state = HeartState.anxious
            }
            */
          //  heartCount+=1
            
            if(heartCount >= 199){
                timer.invalidate()
            }
        }
    }

    // create method that returns the current heartbeat
    
  /*  func setHeartBeat()
    {
        calendarHeartBeat.title = String(heartBeatNum)
        
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
