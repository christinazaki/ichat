

import UIKit
import Firebase
class RoomsVC: UIViewController , UITableViewDelegate,UITableViewDataSource {
   var rooms = [Room]()
    @IBAction func didPressCreateNewRoom(_ sender: UIButton) {
        guard let NewRoom = self.newRoomTF.text, NewRoom.isEmpty == false // lw textfield b false y3ani m4 empty yob2a hykml el code 3adi
            else{
                return
        }
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId() // hna create node rooms lw mafish lw fih hyzawd id gwa child elli esmo rooms
        let dataArray : [String:Any] = ["roomName":NewRoom]
        room.setValue(dataArray) { (error, ref) in
            // setValue a5trt elli b error 34an at2akd en mafish error
            if (error == nil ){
                self.newRoomTF.text = "" // 3la asas lw lma ydos 3la button yshil klam mn tetfield
                
            }
        }
        
    }
    @IBOutlet weak var newRoomTF: UITextField!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.rooms[indexPath.row]
 let chatViewRoom = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomViewController
        chatViewRoom.room = selectedRoom
        self.navigationController?.pushViewController(chatViewRoom, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = roomsTableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        cell.textLabel?.text = room.roomName
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsTableView.delegate = self
        self.roomsTableView.dataSource = self
        observeRooms()
        
    }
    func observeRooms()  {
      let databaseRef = Database.database().reference()
        // observe dih 3amtn btsm3 lma a3'ir f db
        databaseRef.child("rooms").observe(.childAdded) { (snapShot) in
            print(snapShot)// higib data elli mwgoda plus elli adaft
            if let dataArray = snapShot.value as?  [String:Any]{
                print(dataArray)
              //  self.roomsTableView.reloadData()
              if let roomName = dataArray["roomName"] as? String {
               
                    let room = Room.init(roomId: snapShot.key, roomName : roomName )
                
                self.rooms.append(room )
                print("room.roomName")
                self.roomsTableView.reloadData()
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // func dih 34an lw 3iza a3ml 7aga kol m el view dih tazhr y3ani masln lw 3iz a2akd en user dh already user f app h3mlha hna htcheck 3la el current user mawgod lw b nil h3ml dismiss
        if  (Auth.auth().currentUser == nil){ // hna lma h3ml logout w agi aft7 el app current user b nil f m4 hyd5ol hna bsabb el fun viewdidAppear
            self.presentLoginScreen()
        }
        
    }
    @IBAction func didPressLogout(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut() // func el signOut btrmy throw f htar 23aml try w catch f m4 h3ml try w catch h3ml force try eni mot2akd en mafiish error
        // b satr eli fo2 dh 34an 23rf firebase eni logout y3ani el currentUser b nil
        self.presentLoginScreen()
    }
    func presentLoginScreen() {
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        self.present(formScreen,animated: true,completion: nil)
    }
    @IBOutlet weak var roomsTableView: UITableView!
}

