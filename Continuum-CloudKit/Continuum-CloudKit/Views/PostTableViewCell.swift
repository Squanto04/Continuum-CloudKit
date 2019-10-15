//
//  PostTableViewCell.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var post: Post? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        captionTextLabel.text = post.caption
        commentCountLabel.text = "Comments: \(post.comments.count)"
    }

}
