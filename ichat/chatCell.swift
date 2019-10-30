

import UIKit

class chatCell: UITableViewCell {
    enum bubbleType {
        case incoming
        case outgoing
    }
    @IBOutlet weak var chatTextBubble: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      //chatTextBubble.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        
    }
    func setMessageData(message : Message) {
      userNameLabel.text = message.messageName
         chatTextView.text = message.messageText
    }
    func setBubbleType(type : bubbleType)  {
        if (type == .incoming) {
            stackView.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else if (type == .outgoing) {
            stackView.alignment = .trailing
             chatTextBubble.backgroundColor = #colorLiteral(red: 0, green: 0.8133200369, blue: 1, alpha: 1)
        }
    }
}
