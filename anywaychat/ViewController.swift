//
//  ViewController.swift
//  anywaychat
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2017年 nakadoribooks. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreImage

class ViewController: UIViewController, InputFormDelegate
, UITableViewDelegate, UITableViewDataSource {

    private let inputForm = InputForm()
    private let tableView = UITableView()
    private let baseTableHeight:CGFloat = windowHeight() - 64 - InputForm.Height
    private var messageList:[Message] = []
    private var chatRef:DatabaseReference!
    private var userName:String = "iOS"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AloeThread.wait(0.5) { 
            self.setup()
        }
    }
    
    private func setup(){
        setupTableView()
        setupHeader()
        
        inputForm.delegate = self
        view.addSubview(inputForm.view)
        
        let offsetRef = Database.database().reference(withPath: ".info/serverTimeOffset")
        offsetRef.observe(.value, with: { snapshot in
            if let offset = snapshot.value as? TimeInterval {
                Global.timestampOffset = offset
            }
            
            self.setupRef()
        })
    }
    
    private func setupRef(){
        let ref = Database.database().reference()
        let chatId = Global.currentChatId
        self.chatRef = ref.child("chats").child(chatId)
        
        self.chatRef.child("messageList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var results:[Message] = []
            
            var loaded:UInt = 0
            let total = snapshot.childrenCount
            
            if total == 0{
                self.onLoadMessageList()
                return
            }
            
            for child in snapshot.children{
                guard let childSnapshot = child as? DataSnapshot else{
                    continue;
                }
                
                let messageKey = childSnapshot.key
                self.messageRef().child(messageKey).observeSingleEvent(of: .value, with: { (snapshot) in
                    let message = Message(snapshot: snapshot)
                    results.append(message)
                    loaded = loaded + 1
                    if loaded == total{
                        results.sort(by: { (m1, m2) -> Bool in
                            return m1.createdAt.compare(m2.createdAt) == .orderedAscending
                        })
                        
                        self.messageList = results
                        self.onLoadMessageList()
                    }
                    
                })
            }
            
        })
    }
    
    private func onLoadMessageList(){
        print("onLoadMessageList")
        tableView.reloadData()
        
        scrollToBottom()
        
        // subscribe
        self.chatRef.child("messageList").observe(.childAdded, with: { (snapshot) in
            let newMessageKey = snapshot.key
            
            for m in self.messageList{
                if m.key == newMessageKey{
                    return
                }
            }
            
            self.messageRef().child(newMessageKey).observeSingleEvent(of: .value, with: { (snapshot) in
                let message = Message(snapshot: snapshot)
                self.messageList.append(message)
                let indexPath = IndexPath(row: self.messageList.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                if !self.inBottom(){
                    return;
                }
                
                AloeThread.wait(0.2, proc: {
                    self.scrollToBottom()
                })
            })
            
        })
    }
    
    private func messageRef()->DatabaseReference{
        return Database.database().reference().child("messages")
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 64, width: windowWidth(), height: baseTableHeight)
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.tapTable)))
        view.addSubview(tableView)
    }
    
    private dynamic func tapTable(){
        inputForm.blur()
    }
    
    private func setupHeader(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth(), height: 64))
        let bg = UIView()
        bg.frame.size = headerView.frame.size
        bg.backgroundColor = UI.primaryColor
        headerView.addSubview(bg)
        view.addSubview(headerView)
        
        let titleLabel = UILabel(frame: CGRect(x: 44, y: 20, width: windowWidth() - 88, height: 20))
        titleLabel.textColor = UI.whiteColor
        titleLabel.textAlignment = .center
        titleLabel.font = UI.semiBoldFont(size: 20.0)
        titleLabel.text = "AnywayChat"
        headerView.addSubview(titleLabel)
        
        let chatIdLabel = UILabel(frame: CGRect(x: 44, y: 40, width: windowWidth() - 88, height: 20))
        chatIdLabel.font = UI.font(size: 14.0)
        chatIdLabel.textColor = UI.whiteColor
        chatIdLabel.textAlignment = .center
        chatIdLabel.text = Global.currentChatId
        headerView.addSubview(chatIdLabel)
    }
    
    private func inBottom()->Bool{
        let y = tableView.contentSize.height - tableView.frame.size.height - tableView.contentOffset.y
        
        return y <= 20.0
    }
    
    private func scrollToBottom(){
        let toY = tableView.contentSize.height - tableView.frame.size.height
        
        if toY < 0{
            return;
        }
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.tableView.setContentOffset(CGPoint(x: 0, y: toY), animated: true)
        }) { (success) in
            self.tableView.reloadData()
        }
    }
    
    // MARK UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageList[indexPath.row]
        
        return MessageCell.height(message: message)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageCell"
        var cell:MessageCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MessageCell
        
        if cell == nil{
            cell = MessageCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let message = messageList[indexPath.row]
        cell?.reload(message: message)
        
        return cell!
    }

    // MARK InputFormDelegate
    
    private var keyboardHeight:CGFloat = 0
    
    func onHideKeyboard(duration: TimeInterval, curve: UInt) {
        
        keyboardHeight = 0
        
        let toHeight:CGFloat = baseTableHeight
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
            self.tableView.frame.size.height = toHeight
        }, completion: { aaa in
            
        })
    }
    
    func onShowKeyboard(duration: TimeInterval, curve: UInt, keyboardFrame: CGRect) {
        let toHeight:CGFloat = baseTableHeight - keyboardFrame.size.height
        
        var toY = tableView.contentOffset.y
        if inBottom(){
            toY = toY + keyboardFrame.size.height - keyboardHeight
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
            self.tableView.frame.size.height = toHeight
            self.tableView.contentOffset.y = toY
        }, completion: { aaa in
            
        })
        
        keyboardHeight = keyboardFrame.size.height
    }
    
    func onCommitMessage(message: String) {
        
        let createdAt = ServerValue.timestamp()
        
        let messageDic:[String:Any] = [
            "userId": Global.userId,
            "createdAt": createdAt,
            "chat": self.chatRef.key,
            "message": message,
            "userName": userName,
            "platform": PlatformType.ios.val()
        ]
        
        let ref = Database.database().reference()
        let message = ref.child("messages").childByAutoId()
        
        message.setValue(messageDic)
        
        chatRef.child("messageList").child(message.key).setValue(1)
    }

}

