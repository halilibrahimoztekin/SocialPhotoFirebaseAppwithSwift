//
//  FeedViewController.swift
//  SocialPhotoFirebaseAppwithSwift
//
//  Created by Bukefalos on 24.10.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var UserEmailArray = [String]()
    var UserCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()

        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
       // let settings = firestoreDatabase.settings
        //firestoreDatabase.settings = settings
        firestoreDatabase.collection("Posts").order(by: "date",descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.UserEmailArray.removeAll(keepingCapacity: false)
                    self.UserCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        print(documentID)
                        if let postedBy = document.get("postedBy") as? String{
                            self.UserEmailArray.append(postedBy)
                            print(postedBy)
                        }
                        if let postcomment = document.get("postcomment") as? String{
                            self.UserCommentArray.append(postcomment)
                            
                        }
                        if let userimageurl = document.get("imageUrl") as? String{
                            self.userImageArray.append(userimageurl)
                            
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                            
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Prototip hücre olduğundaki konttol yöntemi
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.userEmailText.text = UserEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentText.text = UserCommentArray[indexPath.row]
        cell.documentIdText.text = documentIdArray[indexPath.row]
        let imurl = String(userImageArray[indexPath.row])
        
        // SDImage ile url üzerinden asenkron görüntü alma
        cell.cellImageView.sd_setImage(with: URL(string:imurl), placeholderImage: UIImage(named: "select.png"))
        //cell.cellImageView.image = UIImage(named: "select.png")
        return cell
    }
   
    

}
