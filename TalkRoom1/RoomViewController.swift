//
//  RoomViewController.swift
//  TalkRoom1
//
//  Created by 宮本一彦 on 2016/12/28.
//  Copyright © 2016年 宮本一彦. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellNumber:Int = 0
    
    var roomImageView = UIImageView()
    var roomNameLabel = UILabel()
    var roomName = String()
    
    var roomImageArray = ["one.png","two","three.png","four.png","five.png","six.png","seven.png"]
    var roomNameArray = ["新入社員広場","助け合い広場","業務報告","話そう会","東京憩いの場","関西人集まろか"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }

    // デリゲートメソッド(tableview)
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roomNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Cellのタグ番号をセット
        roomImageView = cell.viewWithTag(1) as! UIImageView
        roomNameLabel = cell.viewWithTag(2) as! UILabel
        
        //　配列の中身をセットする
        roomImageView.image = UIImage(named: roomImageArray[indexPath.row])
        roomNameLabel.text = roomNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellNumber = indexPath.row
        roomName = roomNameArray[indexPath.row]
        
        // pushで画面遷移
        performSegue(withIdentifier: "chat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "chat") {
            
            let chatVC:ChatViewController = segue.destination as! ChatViewController
            
            // 選択された番号・部屋名を入れる
            chatVC.cellNumber = cellNumber
            chatVC.roomName = roomName
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
