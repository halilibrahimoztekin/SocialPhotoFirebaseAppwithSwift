//
//  FeedTableViewCell.swift
//  SocialPhotoFirebaseAppwithSwift
//
//  Created by Bukefalos on 25.10.2021.
//

import UIKit
import Firebase
class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var documentIdText: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var userEmailText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!){
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            fireStoreDatabase.collection("Posts").document(documentIdText.text!).setData(likeStore, merge: true, completion: nil)
        
    }
        
    }
    
}
