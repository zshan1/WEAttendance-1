//
//  ViewController.swift
//  iAttendance
//
//  Created by Prasidha Timsina on 10/12/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class LoginID: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var TextInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        TextInput.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var myVar : String = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login(TextInput.text!)
        // print(self.myVar)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.decide()
        })
        return true
    }
    
    
    func login(_ netid: String) {
        
        let postEndpoint: String = "https://xzhu2.w3.uvm.edu/WeAttend/test.php?netId="+netid
        guard let url = URL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // If data exists, grab it and set it to our global variable
            if (error == nil) {
                let jo : NSDictionary
                do {
                    jo = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                }
                catch {
                    return   print("error trying to convert data to JSON")
                }
                let status = jo["isStudent"] as! String
                print(jo)
                // print("Value for key1 is", jo["isStudent"]!)
                //   print(status)
                self.myVar = status
                // print("555",self.myVar)
            }
            else{
                print("error calling GET on /posts/1")
                print("error")
            }
            // print("666",self.myVar)
        })
        // Return value of returnedUserID
        //print("777",self.myVar)
        task.resume()
        //print("888",self.myVar)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        login(TextInput.text!)
        //print(self.myVar)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.decide()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewClick(_ sender: AnyObject) {
        TextInput.resignFirstResponder()
        
    }
    func decide(){
        if self.myVar == "true"{
            UserDefaults.standard.set(TextInput.text, forKey: "NetID")
            performSegue(withIdentifier: "toMainSegue", sender: self)
        }
        else if self.myVar == "false"{
            let alertController = UIAlertController(title: "Opps!", message: "This is not a correct NetID. Please try again!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

