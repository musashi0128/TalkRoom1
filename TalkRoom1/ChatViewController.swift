//
//  ChatViewController.swift
//  TalkRoom1
//
//  Created by 宮本一彦 on 2016/12/28.
//  Copyright © 2016年 宮本一彦. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {

    var cellNumber:Int = 0
    
    var roomName = String()
    
    var messages:[JSQMessage]! = [JSQMessage]()
    
    var incomingBubble:JSQMessagesBubbleImage!
    var outcomingBubble:JSQMessagesBubbleImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
