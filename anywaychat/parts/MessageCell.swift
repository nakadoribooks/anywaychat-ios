//
//  MessageCell.swift
//  anywaychat
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2017年 nakadoribooks. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    static let messageLabel = UILabel()
    static let nameLabel = UILabel()
    
    static func height(message:Message)->CGFloat{
        return contentSize(message: message).height + 30 + UI.margin * 2.0
    }
    
    static func messageSize(message:Message)->CGSize{
        
        let maxWidth:CGFloat = windowWidth() / 3.0 * 2.0
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: maxWidth, height: 10000)
        messageLabel.font = UI.font(size: 18.0)
        messageLabel.numberOfLines = 0
        messageLabel.text = message.message
        messageLabel.sizeToFit()
        messageLabel.frame.size.width = min(messageLabel.frame.size.width, maxWidth)
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: maxWidth, height: 20)
        nameLabel.font = UI.semiBoldFont(size: 16.0)
        nameLabel.text = message.userName
        nameLabel.sizeToFit()
        nameLabel.frame.size.width = min(nameLabel.frame.size.width, maxWidth)
        
        let width:CGFloat = max(nameLabel.frame.size.width, messageLabel.frame.size.width)
        
        return CGSize(width: width, height: messageLabel.frame.size.height)
    }
    
    static func contentSize(message:Message)->CGSize{
        let messageSize = self.messageSize(message: message)
        
        return CGSize(width: messageSize.width + UI.margin * 2.0, height: messageSize.height + 15 + (UI.margin * 3.0))
    }
    
    private static let Radius:CGFloat = 10.0
    
    private let wrapView = UIView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()
    private var message:Message!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(wrapView)
        wrapView.addSubview(nameLabel)
        wrapView.addSubview(messageLabel)
        wrapView.addSubview(dateLabel)
        
        wrapView.layer.borderColor = UI.greyColor.cgColor
        wrapView.layer.cornerRadius = MessageCell.Radius
        wrapView.layer.borderWidth = 1
        
        nameLabel.frame = CGRect(x: UI.margin, y: UI.margin, width: windowWidth(), height: 20)
        nameLabel.font = UI.semiBoldFont(size: 16.0)
        nameLabel.textColor = UI.textColor
        
        messageLabel.frame = CGRect(x: UI.margin, y: 15.0 + (UI.margin * 2.0), width: 0, height: 0)
        messageLabel.numberOfLines = 0
        messageLabel.font = UI.font(size: 18.0)
        messageLabel.textColor = UI.textColor
        
        dateLabel.font = UI.semiBoldFont(size: 12.0)
        dateLabel.textColor = UI.greyColor
        dateLabel.frame = CGRect(x: 0, y: 0, width: windowWidth() - (UI.margin * 2.0), height: 20)
        
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK public
    
    func reload(message:Message){
        self.message = message
        
        nameLabel.text = message.userName
        
        let messageSize = MessageCell.messageSize(message: message)
        let contentSize = MessageCell.contentSize(message: message)
        
        messageLabel.frame.size = messageSize
        messageLabel.text = message.message
        
        nameLabel.frame.size.width = messageSize.width
        nameLabel.frame.origin.x = UI.margin
        
        dateLabel.frame.origin = CGPoint(x: UI.margin, y: contentSize.height + UI.margin + UI.marginTite)
        dateLabel.text = Global.agoText(message.createdAt)
        
        wrapView.frame = CGRect(x: UI.margin, y: UI.margin, width: contentSize.width, height: contentSize.height)
        
        messageLabel.textAlignment = .left
        nameLabel.textAlignment = .left
        dateLabel.textAlignment = .left
        
        if message.isMymessage(){
            wrapView.frame.origin.x = windowWidth() - wrapView.frame.size.width - UI.margin
            dateLabel.textAlignment = .right
            nameLabel.textAlignment = .right
            messageLabel.textAlignment = .right
        }
    }

}
