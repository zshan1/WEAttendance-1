//
//  ClassList.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit




class ClassList: UIViewController {
    
    @IBOutlet weak var Coursestack: UIStackView!
    @IBOutlet weak var LoadIndicator: UIActivityIndicatorView!
   var classnums = [String]()
   var classsec = [String]()
    
    @IBOutlet weak var NameLabel: UILabel!
   
    @IBAction func Yesbutton(_ sender: UIButton) {
        UserDefaults.standard.set(NetID, forKey: "NetID")
    }
    @IBAction func Nobutton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "NetID")
    }

    override func viewDidLoad() {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        NameLabel.text =  Lastname + ", here are your classes:"
        LoadIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge
        LoadIndicator.center = view.center
        LoadIndicator.hidesWhenStopped = true
        self.LoadIndicator.startAnimating()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        if (Numclass != 0){
            login(NetID)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
                {
                    self.display()
                    
            })
        }else {
            let alertController = UIAlertController(title: "Opps!", message: "You do not have class on your record now. Please contact with registrar office!", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginID")
                self.present(newViewController, animated: false, completion: nil)
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    func login(_ netid: String) {
        
        let postEndpoint: String = "https://www.uvm.edu/~weattend/dbConnection/getStuInfo.php?netId="+netid
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
                let classlist = jo["classList"] as! NSArray
//                print(classlist.count)
//                print(jo)
                
                    for n in 0...Numclass-1
                    {
                        let clas = classlist[n] as! NSDictionary
                        
                        print(clas["courseNum"]!)
                        let CourseS = clas["courseSubj"] as! String
                        let CourseN = clas["courseNum"] as! String
                        if (CourseN.count==1){
                            self.classnums.append(CourseS+" "+"00"+CourseN)
                        }
                        else if (CourseN.count==2){
                            self.classnums.append(CourseS+" "+"0"+CourseN)
                        }
                        else{
                            self.classnums.append(CourseS+" "+CourseN)
                        }
                        let CourseE = clas["section"] as! String
//                        self.classnums.append(CourseS+" "+CourseN)
                        self.classsec.append("Section "+CourseE)
                        
                    }
                
                print(self.classnums)
                print(self.classsec)

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
    
    func display(){
//        let stackView   = UIStackView()
//        stackView.axis  = UILayoutConstraintAxis.vertical
//        stackView.distribution  = UIStackViewDistribution.equalSpacing
//        stackView.alignment = UIStackViewAlignment.center
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
        //Constraints
//        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        for i in 0...Numclass-1{
            let Csubnum = UILabel()
            Csubnum.backgroundColor = UIColor(red:0.69, green:0.69, blue:0.69, alpha: 0.5)
            Csubnum.font = UIFont(name:"Helvetica" ,size: 20)
            Csubnum.widthAnchor.constraint(equalToConstant: self.Coursestack.frame.width).isActive = true
            Csubnum.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            Csubnum.text = classnums[i]+"         "+classsec[i]
            Csubnum.textAlignment = .center
           // Csubnum.font = Csubnum.font.withSize(30)
            Csubnum.textColor = UIColor.white
            Coursestack.addArrangedSubview(Csubnum)
        
        }
       self.LoadIndicator.stopAnimating()
   }
}
