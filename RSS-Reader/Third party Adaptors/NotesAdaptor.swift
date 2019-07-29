//
//  NotesAdaptor.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 29/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation
import Notes

protocol NotesAdaptorProtocol {
    static func addNotes(title:String, description: String,key: String)
}

class NotesAdaptor: NotesAdaptorProtocol {
    static func addNotes(title:String, description: String,key: String) {
        Notes.addNotesWith(title: title, description: description, key: key)
    }
}
