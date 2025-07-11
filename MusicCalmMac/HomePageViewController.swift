//
//  HomePageViewController.swift
//  MusicCalm
//
//  Created by Nithya Appannagaari on 11/28/22.
//

import UIKit
import HealthKit
import AVFoundation

enum HeartState {
    case anxious, stressed, normal
}

var prevState = HeartState.stressed
var state = HeartState.stressed

var heartBeatNums = [Int]()
var player: AVAudioPlayer?

var inGame = false

var heartCount = 0
var songs: [[[String]]?]?
/*
 To-Do for AI Generation of Music
 * play same music on all pages (AVAudioPlayer)
 * use python to train AI models to make music in 5 genres, and 3 levels per genre. 15 sections, 4 songs per section.
 * make sure songs generated flow into each other for different levels
 * categorize each audio file into their respective section
 
 * 5 genres
 * R&B
 * heavy metal
 * classical
 * pop
 * hip hop
 */
@available(iOS 13.0, *)


class HomePageViewController: UIViewController, AVAudioPlayerDelegate{
        
    var pauseCount = 0
        
    var timer = Timer()
    
   
    
    var sum = 0
    
    var timerHeart = Timer()
    @IBOutlet weak var heartBeat: UIBarButtonItem!
    // add 3 more songs to each one
    let rbNorm = ["R&B normal stress 1","r&b normal 2", "r&b normal 3", "r&b normal 4"] //lahari
    let rockNorm = ["rock normal 1", "rock normal 2", "rock normal 3", "rock normal 4"] //lahari
    let classicalNorm = ["classical normal 1", "classical normal 2", "classical normal 3", "classical normal 4"] //lahari
    let popNorm = ["pop normal 1", "pop normal 2", "pop normal 3", "pop normal 4"] //nithya
    let hipNorm = ["Hip normal stress 1", "Hip normal stress 2", "hip-normal-3", "hip normal 4"] //nithya
    
    let rbStress = ["R&B normal stress 1", "r&b stress 2", "r&b stress 3", "r&b stress 4"]
    let rockStress = ["rock stress 1", "rock stress 2", "rock stress 3", "rock stress 4"]
    let classicalStress = ["classical stress 1", "classical stress 2", "classical stress 3", "classical stress 4"]
    let popStress = ["pop stress 1", "pop stress 2", "pop stress 3", "pop stress 4"]
    let hipStress = ["Hip stress 1", "hip stress 2", "hip stress 3", "hip stress 4"]
    
    let rbAnxious = ["R&B high stress 1", "r&b anxious 2", "r&b anxious 3", "r&b anxious 4"]
    let rockAnxious = ["rock anxious 1", "rock anxious 2", "rock anxious 3", "rock anxious 4"]
    let classicalAnxious = ["classical anxious 1", "classical anxious 2", "classical anxious 3", "classical anxious 4"]
    let popAnxious = ["pop anxious 1", "pop anxious 2", "pop anxious 3", "pop anxious 4"]
    let hipAnxious = ["Hip anxious 1", "hip anxious 2", "hip anxious 3", "hip anxious 4"]
    
    var norm: [[String]]?
    var stress: [[String]]?
    var anxious: [[String]]?
    
    // indices:
    // 0-3 --> normal and classical
    // 4-7 -->
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        norm = [rbNorm, rockNorm, classicalNorm, popNorm, hipNorm]
        
        stress = [rbStress, rockStress, classicalStress, popStress, hipStress]
        
        anxious = [rbAnxious, rockAnxious, classicalAnxious, popAnxious, hipAnxious]
        //           normal           stress          anxious
        songs =  [norm, stress, anxious]// store all 60 audio files in here
       
        let healthStore = HealthKitInterface(self)
        healthStore.readHeartRateData()
        self.setHeartBeat()
        playSong()
        timerHeart = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                    self.setHeartBeat()
                }
        }
        
    
    func setHeartBeat()
    {
       // heartBeat.title = String(heartBeatNum)
        
        prevState = state
        print("setting heart beat")
        
        if(heartBeatNums != nil && !heartBeatNums.isEmpty)
        {
            let num = heartBeatNums[heartCount]
            sum = sum + num
            
            heartBeat?.title = String(num)
            CalendarViewController().calendarHeartBeat?.title = String(num)
            MusicTuningViewController().tuningHeartBeat?.title = String(num)
            WaveViewController().calmHeartBeat?.title = String(num)
            
            print("title is \(num)")
            
            var avNum = num
            
            if((heartCount + 1)%3 == 0){
                avNum = Int(sum/3)
                sum = 0
                
                if(avNum < 90) {
                    state = HeartState.normal
                }
                
                else if(avNum >= 90 && avNum < 120)
                {
                    state = HeartState.stressed
                }
                
                else if(avNum >= 120)
                {
                    state = HeartState.anxious
                }
            }
            
            heartCount+=1
            
            if(heartCount >= 199){
                timerHeart.invalidate()
            }
        }
        
        print(state)
        
        if(stateHasChanged() && !inGame)
        {
            // add transition
            self.playSong()
        }
    }
    
    func stateHasChanged() -> Bool {
        return (prevState != state)
    }
    
    func playSong()
    {
        if(!inGame)
        {
            var stateIndex = 2 // stress state
            
            //let genreIndex = 2 // 0 --> rnb
            
            if (state == HeartState.normal) {
                stateIndex = 0
            }
            else if (state == HeartState.stressed) {
                stateIndex = 1
            }
            
            let randomSongInd = Int.random(in: 0...3)
            
            let urlString = Bundle.main.path(forResource: songs?[stateIndex]?[genreInd][randomSongInd], ofType: "mp3")
            
            do {
                
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                player?.delegate = self
                
                guard let player = player else {
                    return
                }
                
                player.play()
            } catch {
                print("something went wrong")
            }
        }
    
    }
  
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        self.playSong()
    }
    
    func stopStong()
    {
        player?.stop()

    }
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
}
