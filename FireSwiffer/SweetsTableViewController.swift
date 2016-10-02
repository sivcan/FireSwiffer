//
//  SweetsTableViewController.swift
//  FireSwiffer
//
//  Created by Sivcan Singh on 02/10/16.
//  Copyright © 2016 Sivcan Singh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SweetsTableViewController: UITableViewController {
    
    var dbRef : FIRDatabaseReference!
    var sweets = [Sweet]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addStateDidChangeListener( { (auth: FIRAuth, user:FIRUser?) in
            if let user = user {
                print("Welcome \(user.email!)")
                self.startObservingDB()
            }else {
                print("You need to sign up / login first")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("sweet-items")
        startObservingDB()
    }
    
    @IBAction func loginAndSignUp(_ sender: AnyObject) {
        
        let userAlert = UIAlertController(title: "Login/Sign Up", message: "Enter email & password", preferredStyle: .alert)
        userAlert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "email"
        })
        
        userAlert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "password"
        })
        
        userAlert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!,  password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print(user?.email)
                    print("Successfully logged in!")
                }else {
                    print(error)
                }
            }

        }))
        
        
        userAlert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print(user?.email)
                    print("User creation successful!")
                }else {
                    print(error)
                }
            }

        }))
        
        self.present(userAlert, animated: true, completion: nil)
        
    }
    
    
    func startObservingDB() {
        dbRef.observe(.value, with : { (snapshot: FIRDataSnapshot) in
            var newSweets = [Sweet]()
            for sweet in snapshot.children {
                let sweetObject = Sweet(snapshot: sweet as! FIRDataSnapshot)
                newSweets.append(sweetObject)
            }
            self.sweets = newSweets
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func addSweet(_ sender: AnyObject) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your sweet", preferredStyle: .alert)
        sweetAlert.addTextField(configurationHandler: {(textField : UITextField) in
            textField.placeholder = "Your Sweet"
        })
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {(action: UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text {
                    let sweet = Sweet(content: sweetContent, addedByUser: "Sivcan Singh")
                
                    let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.getVal())
            }
        }))
        
            self.present(sweetAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation,  the number of rows
        return sweets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let sweet = sweets[indexPath.row]
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.addedByUser
        return cell
    }
    

   
}
