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
    private var userName:String = Global.currentName
    private let qrOverlay = UIView(frame: windowFrame())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AloeThread.wait(0.5) { 
            self.setup()
        }
    }
    
    private func setup(){
        setupRef()
        setupTableView()
        setupHeader()
        
        inputForm.delegate = self
        view.addSubview(inputForm.view)
        
        qrOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.hideQr)))
        
        let offsetRef = Database.database().reference(withPath: ".info/serverTimeOffset")
        offsetRef.observe(.value, with: { snapshot in
            if let offset = snapshot.value as? TimeInterval {
                Global.timestampOffset = offset
            }
            
            self.loadMessageList()
        })
    }
    
    private func setupRef(){
        let ref = Database.database().reference()
        if let chatId = Global.currentChatId{
            self.chatRef = ref.child("chats").child(chatId)
        }else{
            self.chatRef = ref.child("chats").childByAutoId()
            Global.currentChatId = self.chatRef.key
        }
    }
    
    private func loadMessageList(){
        
        // 最初の読み込み
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
        tableView.reloadData()
        
        scrollToBottom()
        
        // 監視
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
                
                AloeThread.wait(0.4, proc: {
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
        
        let qrButton = UIButton(frame: CGRect(x: windowWidth()-44-UI.marginTite, y: 20, width: 44, height: 44))
        headerView.addSubview(qrButton)
        let qrImageView = UIImageView(image: UIImage(named:"qr"))
        qrImageView.frame = CGRect(x: UI.marginTite, y: UI.marginTite, width: 44 - (UI.marginTite * 2.0), height: 44 - (UI.marginTite * 2.0))
        qrButton.addSubview(qrImageView)
        
        qrButton.addTarget(self, action: #selector(ViewController.tapQr), for: .touchUpInside)
    }
    
    private dynamic func tapQr(){
        inputForm.blur()
        
        let qrUrl = "anywaychat://" + self.chatRef.key
        let data = qrUrl.data(using: String.Encoding.utf8)!
        let qr = CIFilter(name: "CIQRCodeGenerator", withInputParameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!

        let sizeTransform = CGAffineTransform(scaleX: 8, y: 8)
        let qrImage = UIImage(ciImage: qr.outputImage!.applying(sizeTransform))
        
        let qrImageView = UIImageView(image: qrImage)
        qrImageView.frame = CGRect(x: (windowWidth() - qrImage.size.width) / 2.0, y: (windowHeight() - qrImage.size.height) / 2.0, width: qrImage.size.width, height: qrImage.size.height)
        qrImageView.alpha = 0
        qrImageView.isUserInteractionEnabled = false
        
        let blackLayer = UIView(frame: windowFrame())
        blackLayer.alpha = 0
        blackLayer.backgroundColor = UIColor.black
        
        qrOverlay.addSubview(blackLayer)
        qrOverlay.addSubview(qrImageView)
        qrOverlay.alpha = 1.0
        view.addSubview(qrOverlay)
        
        AloeChain().add(0.2, ease: .Ease) { (val) in
            blackLayer.alpha = 0.8 * val
        }.add(0.2, ease: .Ease) { (val) in
            qrImageView.alpha = val
        }.execute()
    }
    
    private dynamic func hideQr(){
        AloeChain().add(0.2, ease: .Ease) { (val) in
            self.qrOverlay.alpha = 1.0 - val
        }.call {
            self.qrOverlay.removeFromSuperview()
            for subview in self.qrOverlay.subviews{
                subview.removeFromSuperview()
            }
        }.execute()
    }
    
    private func inBottom()->Bool{
        let y = tableView.contentSize.height - tableView.frame.size.height - tableView.contentOffset.y
        
        return y <= 100.0
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
            if tableView.contentSize.height > toHeight{
                toY = toY + keyboardFrame.size.height - keyboardHeight
            }
        }
        
        toY = max(0, min(toY, tableView.contentSize.height - toHeight))
        
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

