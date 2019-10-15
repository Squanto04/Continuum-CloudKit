//
//  PostController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PostController {
    
    // MARK: - Shared Instance - Singleton
    static let shared = PostController()
    
    // MARK: - Source of Truth
    var posts: [Post] = []
    
    // Add Comment
    func addComment(text: String, post: Post, completion: @escaping (_ comment: Comment) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (_ post: Post) -> Void) {
        let newPost = Post(photo: image, caption: caption)
        posts.append(newPost)
    }
    
}
