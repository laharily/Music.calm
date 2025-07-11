//
//  WaveViewController.swift
//  MusicCalm
//
//  Created by Nithya Appannagaari on 12/3/22.
//

import UIKit
@available(iOS 13.0, *)

class WaveViewController: UIViewController {
    
    var pauseCount = 0
  
    @IBOutlet weak var calmHeartBeat: UIBarButtonItem!
    
    var timer = Timer()
    
    override func loadView()
    {
        super.loadView()
    //    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
          //          self.setHeartBeat()
      //          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
       self.setHeartBeat()
       self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.setHeartBeat()
            })

        // Do any additional setup after loading the view.
    }
    
    // create method that returns the current heartbeat
    
    /*func setHeartBeat()
    {
        calmHeartBeat.title = String(heartBeatNum)
        
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
    
    func setHeartBeat()
    {
       // heartBeat.title = String(heartBeatNum)
        
        print("setting heart beat")
        
        if(heartBeatNums != nil && !heartBeatNums.isEmpty)
        {
            let num = heartBeatNums[heartCount]
            
            calmHeartBeat?.title = String(num)
            
            print("title is \(num)")
            
         /*   if(num < 90) {
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
            
          //  heartCount+=1
            
            if(heartCount >= 199){
                timer.invalidate()
            }
        }
    }
    
    @IBAction func openInsta(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/music.calm2023/")! as URL, options: [:], completionHandler: nil)
    }
    
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
