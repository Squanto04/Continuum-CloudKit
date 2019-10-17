//
//  Post.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit
import CloudKit

struct PostStrings {
    static let recordTypeKey = "Post"
    fileprivate static let captionKey = "caption"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let commentsKey = "comments"
    fileprivate static let photoAssetKey = "photoAsset"
    static let commentCountKey = "commentCount"
}

class Post {
    var timestamp: Date
    var caption: String
    var commentCount: Int
    var comments: [Comment]
    let recordID: CKRecord.ID
    var postPhoto: UIImage? {
        get{
            guard let photoData = self.photoData else { return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    var photoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString)
                .appendingPathComponent("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage? = nil, caption: String, timestamp: Date = Date(), comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.postPhoto = photo
    }
}

/// Post -> Cloud
extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordTypeKey, recordID: post.recordID)
        self.setValuesForKeys([
            PostStrings.captionKey : post.caption,
            PostStrings.timestampKey : post.timestamp,
            PostStrings.commentsKey : post.comments,
            PostStrings.commentCountKey : post.commentCount
            ])
    }
}

/// Cloud -> Post
extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostStrings.captionKey] as? String,
            let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
            let comments = ckRecord[PostStrings.commentsKey] as? [Comment],
            let commentCount = ckRecord[PostStrings.commentCountKey] as? Int
            else { return nil }
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[PostStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }
        self.init(photo: foundPhoto, caption: caption, timestamp: timestamp, comments: comments, recordID: ckRecord.recordID, commentCount: commentCount)
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    }
}
