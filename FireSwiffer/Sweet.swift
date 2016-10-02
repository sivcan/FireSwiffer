//
//  Sweet.swift
//  FireSwiffer
//
//  Created by Sivcan Singh on 02/10/16.
//  Copyright © 2016 Sivcan Singh. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key: String!
    let content: String!
    let addedByUser: String!
    let itemRef:FIRDatabaseReference?
    
    init(content:String, addedByUser:String, key:String = "") {
        self.key = key
        self.addedByUser = addedByUser
        self.content = content
        self.itemRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let dict = snapshot.value as? NSDictionary, let postContent = dict["content"] as? String {
            content = postContent
        }else {
            content = ""
        }
        
        if let dict = snapshot.value as? NSDictionary, let postContent = dict["addedByUser"] as? String {
            addedByUser = postContent
        }else{
            addedByUser = ""
        }
        
        
    }
    
    func getVal() -> NSDictionary {
        return ["content" : content, "addedByUser" : addedByUser]
    }
    
    
}
