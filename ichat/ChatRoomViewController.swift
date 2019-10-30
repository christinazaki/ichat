//
//  ChatRoomViewController.swift
//  ichat
//
//  Created by iMac on 10/30/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessages[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! chatCell
        cell.userNameLabel.text = message.messageName
        cell.chatTextView.text = message.messageText
     
        
chatTableView.rowHeight = cell.chatTextView.contentSize.height
       
        return cell
    }
    

    var room : Room?
    var chatMessages = [Message]()
    @IBOutlet weak var chatTableView: UITableView!
    @IBAction func didPressSendBtn(_ sender: Any) {
        guard let chatText = self.chatTextField.text, chatText.isEmpty == false
            else{
                return
        }
        sendMessage(text: chatText) { (isSucess) in
            if(isSucess == true){
                print("g")
            }
        }
    }
    @IBOutlet weak var chatTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
      
      observeMessages()
    }
    func getUsernameWithID(id : String , completion :@escaping  (_ userName :String?)->()){
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(id) // hna create node rooms lw mafish lw fih hyzawd id gwa child elli esmo rooms
        user.child("userName").observeSingleEvent(of: .value) { (snapShot) in
            if let userName =  snapShot.value as? String{
                completion(userName)
            }else{
                completion(nil)
            }
        }}
    func sendMessage(text : String , completion : @escaping (_  isSucess : Bool)-> ()) // completion dih zi el return eni httnafz lma andiha
    {
        guard let userID =
            Auth.auth().currentUser?.uid// lw textfield b false y3ani m4 empty yob2a hykml el code 3adi
            else{
                return
        }
         let databaseRef = Database.database().reference()
        getUsernameWithID(id: userID) { (userName) in
            if let userName =  userName{
                if let roomID = self.room?.roomId ,let userId = Auth.auth().currentUser?.uid
                {
                    let dataArray :[String:Any] = ["senderName":userName ,"text":text, "senderId" : userId]
                    let room = databaseRef.child("rooms").child(roomID)
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                        if (error == nil ){
                            completion(true)
                            // self.chatTextField.text = ""
                        }
                        else {
                            completion(false)
                        }
                    })
                }
                print(userName)
            }
        }
        
        }// observeSingleEvent bsabb eni mot2akd en elli mwgod 7aga w7da
    func observeMessages() {
        guard let roomID = (self.room?.roomId) else{return}
        let databaseRef = Database.database().reference() .child("rooms").child(roomID).child("messages").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any]{
                guard let senderName = dataArray["senderName"] as? String ,let text = dataArray["text"] as? String
                    else {
                    return
                }
                let message = Message.init(messageKey: snapshot.key, messageName: senderName, messageText: text )
                
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
            }
        }
    }
    }
   

