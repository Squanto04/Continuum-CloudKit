//
//  Comment.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation
import CloudKit

struct CommentString {
    static let recordTypeKey = "Comment"
    fileprivate static let textKey = "text"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let postKey = "post"
    static let postReferenceKey = "postReference"
}

class Comment {
    let text: String
    let timestamp: Date
    weak var post: Post?
    let recordID: CKRecord.ID
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord, post: Post) {
        guard let text = ckRecord[CommentString.textKey] as? String,
            let timestamp = ckRecord[CommentString.timestampKey] as? Date
            else { return nil }
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentString.recordTypeKey, recordID: comment.recordID)
        self.setValuesForKeys([
            CommentString.textKey : comment.text,
            CommentString.timestampKey : comment.timestamp
            ])
        self.setValue(comment.postReference, forKey: CommentString.postReferenceKey)
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}
