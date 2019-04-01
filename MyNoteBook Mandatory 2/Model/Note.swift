//
//  Note.swift
//  MyNoteBook Mandatory 2
//
//  Created by Jakob Wulff on 22/02/2019.
//  Copyright © 2019 Jakob Wulff. All rights reserved.
//

import UIKit

class Note: NSObject, NSCoding {
    
    var headline: String!
    var note: String!
    
    init(headline: String, note: String){
        self.headline = headline
        self.note = note
    }
    
    init(json: [String: Any])
    {
        self.headline = json["headline"] as? String
        self.note = json["note"] as? String
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.headline, forKey: "headline")
        aCoder.encode(self.note, forKey: "note")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.headline = aDecoder.decodeObject(forKey: "headline") as? String
        self.note = aDecoder.decodeObject(forKey: "note") as? String
    }
}



