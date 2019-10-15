
//
//  PostDetailTableViewController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    var post: Post?{
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var followpostButton: UIButton!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonDesign()
    }
    
    // MARK: - Actions
    @IBAction func commentButtonTapped(_ sender: Any) {
        addNewCommentAlert(for: post)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func followpostButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = post else { return 0 }
        return post.comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCommentsCell", for: indexPath)
        if let post = post {
            let comment = post.comments[indexPath.row]
            cell.textLabel?.text = comment.text
            cell.detailTextLabel?.text = comment.timestamp.asString()
        }
        return cell
    }
    
    // MARK: - Alert Controller
    private func addNewCommentAlert(for post: Post?) {
        let alert = UIAlertController(title: "New Comment", message: "Add a new comment below", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        let okayAction = UIAlertAction(title: "OK", style: .default) { (_) in
          guard let post = post,
            let comment = alert.textFields?.first?.text,
            !comment.isEmpty
            else { return }
            PostController.shared.addComment(text: comment, post: post, completion: { (_) in
                // TODO: Add Comment
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Functions
    private func updateButtonDesign() {
        commentButton.layer.cornerRadius = 5
        shareButton.layer.cornerRadius = 5
        followpostButton.layer.cornerRadius = 5
    }
    
    private func updateViews() {
        guard let post = post else { return }
        DispatchQueue.main.async {
            self.postImageView.image = post.photo
        }
    }
    
}
