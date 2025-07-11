//
//  MusicGameViewController.swift
//  MusicCalm
//
//  Created by Nithya Appannagaari on 12/3/22.
//

import UIKit
import AVFoundation
@available(iOS 13.0, *)

class MusicGameViewController: UIViewController, AVAudioPlayerDelegate {
    
    var pauseCount = 0
    
    var startCount = 0
   
   
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var keyB: UIButton!
    @IBOutlet weak var keyA: UIButton!
    @IBOutlet weak var keyC: UIButton!
    @IBOutlet weak var keyD: UIButton!
    @IBOutlet weak var keyE: UIButton!
    @IBOutlet weak var gameHeartBeat: UIBarButtonItem!
    @IBOutlet weak var keyG: UIButton!
    @IBOutlet weak var keyF: UIButton!
    @IBOutlet weak var firstBlack: UIButton!
    @IBOutlet weak var fifthBlack: UIButton!
    @IBOutlet weak var fourthBlack: UIButton!
    @IBOutlet weak var thirdBlack: UIButton!
    @IBOutlet weak var secondBlack: UIButton!
    var timerGame = Timer()
    
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    let startTime = DispatchTime.now()
    
    var Keys: [UIButton] = [UIButton]()
    
    let pianoSongs = ["gameMusic", "gameMusic2", "gameMusic3"]
    
    let tempo = [0.5, 1.1, 0.83]
   
    //no penalty for the game!
    //just press the buttons and benefit from the music
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        player?.pause()
        
        // start text for button
        startButton.titleLabel?.font = UIFont(name: "Coyote SemiBold DEMO", size: 18)
        startButton.setTitleColor(UIColor.blue, for: .normal)
        startButton.setTitle("start", for: .normal)
        
        //pause regular music
        self.pauseButton?.image = UIImage(contentsOfFile: "play.circle")
        
        // hide back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // set up keys in array
        self.Keys = [self.keyA, self.keyB, self.keyC, self.keyD, self.keyE, self.keyF, self.keyG,
                     self.firstBlack, self.secondBlack, self.thirdBlack, self.fourthBlack, self.fifthBlack]
        for key in Keys {
            key.setTitle("", for: .normal)
            key.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        inGame = true
        player?.pause()
    }
     
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        inGame = false
        var songIndex = 2 // stress state
        
        /*
         var genreIndex = 4
         
         if(genre == "R&B")
         {
         genreIndex = 0
         }
         
         else if(genre == "Rock")
         {
         genreIndex = 1
         }
         
         else if(genre == "Classical)
         {
         genreIndex = 2
         }
         
         else if(genre == "Pop")
         {
         genreIndex = 3
         }
         
         */
        
        let genreIndex = 2 // 0 --> rnb
        
        if (state == HeartState.normal) {
            songIndex = 0
        }
        else if (state == HeartState.stressed) {
            songIndex = 1
        }
        
        let randomSongInd = Int.random(in: 0...3)
        
        let urlString = Bundle.main.path(forResource: songs?[songIndex]?[genreIndex][randomSongInd], ofType: "mp3")
        
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
    
    
    @IBAction func buttonPressed(_ sender:  UIButton) {
        startCount = startCount + 1
        
        if(startCount % 2 == 1)
        {
            startButton.setTitle("stop", for: .normal)
            for key in Keys {
                key.isEnabled = true
            }
            self.playSong()
        }
        
        else
        {
            startButton.setTitle("start", for: .normal)
            for key in Keys {
                key.isEnabled = false
            }
            self.stopSong()
        }
    }
    
    func stopSong()
    {
        player?.stop()
        resetGreens()
        timerGame.invalidate()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        resetGreens()
        playSong()
    }
    
    //resetting the piano key back to normal design
    @IBAction func changeKeyBorder(_ sender: UIButton) {
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.black.cgColor
    }
    
    func playSong()
    {
        let songIndex = Int.random(in: 0...2)
        
        let urlString = Bundle.main.path(forResource: pianoSongs[songIndex], ofType: "mp3")
        
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
        
        timerGame.invalidate()
        self.timerGame = Timer.scheduledTimer(withTimeInterval: tempo[songIndex], repeats: true, block: { _ in self.highlightKey()})
    }
    
   
    // this method gets called in accordance with the bpm of the song
    func highlightKey()
    {
            resetGreens()
            // choose a random key
            let index = Int.random(in: 0...11)
            // highlight it
            Keys[index].layer.borderWidth = 5
            Keys[index].layer.borderColor = UIColor.green.cgColor
    }
    
    // create method that returns true if there are other keys that are highlighted green
    func resetGreens() {
        for key in Keys{
            key.layer.borderWidth = 3
            key.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func openInsta(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/music.calm2023/")! as URL, options: [:], completionHandler: nil)
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
