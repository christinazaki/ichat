

import UIKit
import Firebase
class ViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as!FormCell
        if (indexPath.row == 0){ // cell login
            cell.userNameContainer.isHidden = true
            cell.actionBtn.setTitle("Login", for: .normal)
              cell.slideBtn.setTitle("sign Up 👈", for: .normal)// el emotion cmd ctrl space
            cell.slideBtn.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)
            // lma htouch 3lih hynafz dih el func slideToSignInCell
           // cell.slideBtn.addTarget(self, action: #selector(slideToSignInCell(_:)), for: .touchUpInside)// action bt3 el btn y3ani kol lma ydos 3lih hynfz el func
            cell.actionBtn.addTarget(self, action: #selector(didPressSignIn), for: .touchUpInside)
        }
        else if (indexPath.row == 1){// cell signup
             cell.userNameContainer.isHidden = false
            cell.actionBtn.setTitle("sign Up 👈", for: .normal)
            cell.slideBtn.setTitle("Login ", for: .normal)
             cell.slideBtn.addTarget(self, action: #selector(slideToSignUpCell(_:)), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func didPressSignUp(_ sender : UIButton)    {
         print("sss")
        let indexPath = IndexPath(row: 1, section: 0)
           print("iii")
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
          print("ccc")
        guard let emailAddress = cell.emailTF.text,
        let password = cell.passwordTF.text
           
            else{
                print("yyy")
                return
            }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if (error == nil){
                print(result )
                  print(result?.user.uid)
                guard let userId = result?.user.uid , let userName = cell.usernameTF.text
                    else{
                        return
                }
                 self.dismiss(animated: true, completion: nil)
                let reference = Database.database().reference()
                let user = reference.child("users").child(userId)
                print("jjjj")
                let dataArray : [String:Any] = ["userName":userName]
                user.setValue(dataArray)
            }
        }
       
    }
    @objc func didPressSignIn(_ sender : UIButton)    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! FormCell
        guard let emailAddress = cell.emailTF.text, // guard dih 34an el nil w garbage
            let password = cell.passwordTF.text
            else{
                return
        }
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if (error == nil){
              self.dismiss(animated: true, completion: nil)
                print("nnn")// hna 34an lw f error f el username w pass
            }
        }
    }
    @objc func slideToSignUpCell(_ sender:UIButton)// @objc 34an htsd5dm f el addtarget
    {
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true) // m3ana kda eno hyscroll horz ll indexPath dh
    }
    @objc func slideToSignInCell(_ sender:UIButton)// @objc 34an htsd5dm f el addtarget
    {
        let indexPath = IndexPath(row:1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true) // m3ana kda eno hyscroll horz ll indexPath dh bs lazem al3'i el scroll mn storyboard uncheck  3la rnable scroll
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
     
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return collectionView.frame.size // dh 7agm el collection kolha
    }
}

