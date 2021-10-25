//
//  UploadViewController.swift
//  SocialPhotoFirebaseAppwithSwift
//
//  Created by Bukefalos on 24.10.2021.
//

import UIKit
import Firebase
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
  

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        shareButton.isEnabled = false
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let uuid = UUID().uuidString
        // Post Paylaşımı Yapma
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.6){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, hata in
                if hata != nil{
                    self.makeAlert(titleInput: "Error", messageInput: hata?.localizedDescription ?? "Error")
                }
                else
                {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            // Firestore Database ile verileri yükleme
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!
                                                 , "postedBy" : Auth.auth().currentUser!.email!
                                                 ,"postcomment" : self.descText.text!
                                                 ,"date" : FieldValue.serverTimestamp()
                                                 ,"likes" : 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                                }
                                else {
                                    
                                    // yüklemeden sonra anasayfaya yönlendir girişleri boşalt
                                    self.descText.text = ""
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    // Resim Seçme
    @objc func selectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    

}
