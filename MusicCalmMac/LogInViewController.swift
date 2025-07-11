//
//  LogInViewController.swift
//  MusicCalmMac
//
//  Created by Nithya Appannagaari on 12/25/22.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()

        // Do any additional setup after loading the view.
    }
    
    func initializeHideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }

    @IBAction func signIn(_ sender: UIButton) {
        var accountName = ""
        var passwordName = ""
        
        var accountsArray = [""]
        var passwordsArray = [""]
        //NEXT STEP --> change code to read from the whole file and see if they can just find it.
        // steps:
        // store read usernames and passwords into two arrays
        // check if the read usernames + passwords exist in those arrays
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            print("hello")
            let accountFileURL = dir.appendingPathComponent("Accounts")
            
            do{
                accountName = try String(contentsOf: accountFileURL, encoding: .utf8)
                accountsArray = accountName.components(separatedBy: .newlines)
                print(accountsArray)
            } catch{
                sender.layer.borderColor = UIColor.red.cgColor
                sender.layer.borderWidth = 2
                return
            }
            
            let passwordFileURL = dir.appendingPathComponent("Passwords")
            
            do{
                passwordName = try String(contentsOf: passwordFileURL, encoding: .utf8)
                passwordsArray = passwordName.components(separatedBy: .newlines)
                print(passwordsArray)
            } catch {
                sender.layer.borderColor = UIColor.red.cgColor
                sender.layer.borderWidth = 2
                return
            }
        }
        
        let enteredName = username.text!
        let enteredPass = password.text!
        
        if(accountsArray.contains(enteredName) && passwordsArray.contains(enteredPass))
        {
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 2
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarID") as? TabBarViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
            print(accountsArray)
        }
        
        else
        {
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 2
            print(accountsArray)
        }
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
