//
//  ViewController.swift
//  SocialPhotoFirebaseAppwithSwift
//
//  Created by Bukefalos on 24.10.2021.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    

    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        //  Firebase Giriş Yapma
        
        if emailText.text != "" && passText.text != ""
        {
            Auth.auth().signIn(withEmail: emailText.text!, password: passText.text!) { datacall, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        }
        
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
        print("clicked")
    }
    @IBAction func signUpClicked(_ sender: Any) {
       // Firebase Kayıt
        
        if emailText.text   != "" && passText.text != ""
        {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passText.text!)
                    { (authdata, error) in
                            
                            if error != nil {
                                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                            } else {
                                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                                
                            }
                        }
            
            
            
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Fill Password / Email")
        }
        
        
    }
    
    // Alert Oluşturma
    func makeAlert(titleInput : String, messageInput : String ){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

