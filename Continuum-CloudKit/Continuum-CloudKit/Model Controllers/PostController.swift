//
//  PostController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    // MARK: - Shared Instance - Singleton
    static let shared = PostController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Source of Truth
    var posts: [Post] = []
    
    // Add Comment - Locally
    func addComment(text: String, post: Post, completion: @escaping (_ comment: Comment) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func saveComment(with text: String, post: Post, completion: @escaping (_ success: Bool) -> Void) {
        let newComment = Comment(text: text, post: post)
        let commentRecord = CKRecord(comment: newComment)
        publicDB.save(commentRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savedComment = Comment(ckRecord: record, post: post)
                else { completion(false) ; return }
            self.posts.first?.comments.append(savedComment)
            completion(true)
        }
    }
    
    // New Post - Locally
    func createPostWith(image: UIImage, caption: String, completion: @escaping (_ post: Post) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        posts.append(newPost)
    }
    
    // New Post - CloudKit
    func savePost(with text: String, photo: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        let newPost = Post(photo: photo, caption: text)
        let postRecord = CKRecord(post: newPost)
        publicDB.save(postRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savedPost = Post(ckRecord: record)
                else { completion(false) ; return }
            
            self.posts.append(savedPost)
            print("Post Saved Successfully")
            completion(true)
        }
    }
    
    // Fetch Posts
    func fetchPosts(completion: @escaping (_ posts: [Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (foundPosts, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let records = foundPosts else { return }
            let posts = records.compactMap( { Post(ckRecord: $0) } )
            self.posts = posts
            completion(posts)
        }
    }
    
    // Fetch Comments
    func fetchComments(for post: Post, completion: @escaping (_ comment: [Comment]?) -> Void) {
        let postRefence = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentString.postReferenceKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (foundComments, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            guard let records = foundComments else { completion(nil); return }
            let comments = records.compactMap{ Comment(ckRecord: $0, post: post) }
            post.comments.append(contentsOf: comments)
            print("Found Comments for Post")
            completion(comments)
        }
    }
    
    func incrementCommentCount(for post: Post, completion: ((Bool)-> Void)?){
        post.commentCount += 1
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        modifyOperation.savePolicy = .changedKeys
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else {
                completion?(true)
            }
        }
        publicDB.add(modifyOperation)
    }
}
