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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("sweet-items")
    }
    
    func startObservingDB() {
        
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
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        return cell
    }
    

   
}
