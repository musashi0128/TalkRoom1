//
//  ViewController.swift
//  TalkRoom1
//
//  Created by 宮本一彦 on 2016/12/27.
//  Copyright © 2016年 宮本一彦. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var name = String()
    var base64String = String()
    var userid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.bounces = false
        let gifData = NSData(contentsOfFile: Bundle.main.path(forResource: "cc", ofType: "gif")!)
        webView.load(gifData as! Data, mimeType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL() as URL)
        
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.frame = CGRect(x: self.view.frame.size.width/10, y: view.frame.size.height/2, width: view.frame.size.width-(self.view.frame.size.width/10 + view.frame.size.width/10), height: 50)
        self.view.addSubview(fbLoginButton)
        
        fbLoginButton.delegate = self
        
        // ログインして入れば、起動時に画面を次に飛ばす
        if UserDefaults.standard.object(forKey: "OK") != nil {
            
            print("一度ログインしているので、次の画面へ遷移")
            performSegue(withIdentifier: "next", sender: nil)
        }
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            //エラー時
            print("Error")
            print(error)
            
        } else if result.isCancelled {
            //
        
            
        } else {
            //取得
            getFacebookUserInfo()
        }
    }
    
    func getFacebookUserInfo() {
        //FBの情報を取得
        
        if FBSDKAccessToken.current() != nil {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fileds": "id,name"]).start{
                (connection,result,error) in
                
                self.name = (result! as AnyObject).value(forKey: "name") as! String
                let id = (result! as AnyObject).value(forKey: "id")
                // FBより写真を取ってくる
                let url = URL(string: "https://graph.facebook.com/\(id!)/picture?type=large&return_ssl_resources=1")
                let dataURL = NSData(contentsOf: url!)
                
                self.base64String = dataURL!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
                
                //アプリ内へ保存する
                UserDefaults.standard.set(self.base64String, forKey: "profileImage")
                UserDefaults.standard.set(self.name, forKey: "name")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                FIRAuth.auth()?.signIn(with: credential){
                    (user,eeror) in
                    if UserDefaults.standard.object(forKey: "OK") != nil {
                        // 一度ログインしているので、飛ばします
                        
                    } else {
                        self.userid = user!.uid
                        self.createNewUserDB()
                    }
                }
            }
            
            performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    func createNewUserDB() {
        // サーバーに情報を飛ばす
        let firebase = FIRDatabase.database().reference(fromURL:"https://talkroom1-307d5.firebaseio.com/")
        
        // サーバーに飛ばすBox
        let user:NSDictionary = ["username":self.name,"profileImage":self.base64String,"userid":self.userid]
        
        firebase.child("users").childByAutoId().setValue(user)
        
        UserDefaults.standard.set("OK", forKey: "OK")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log out")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

