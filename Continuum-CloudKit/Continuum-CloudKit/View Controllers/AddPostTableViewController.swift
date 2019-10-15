//
//  AddPostTableViewController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/15/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        designButtonView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postImageView.image = UIImage(named: "spaceEmptyState")
        selectImageButton.setTitle("Select Image", for: .normal)
        commentTextField.text = ""
    }
    
    // MARK: - Actions
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        selectImageButton.setTitle(nil, for: .normal)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func tapGestureRecognizer(_ sender: Any) {
        self.commentTextField.resignFirstResponder()
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let postCaption = commentTextField.text,
            !postCaption.isEmpty,
            let image = postImageView.image
            else { return }
            
            PostController.shared.createPostWith(image: image, caption: postCaption) { (_) in
            }
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Helper Functions
    func designButtonView() {
        addPostButton.layer.cornerRadius = 5
    }

}

extension AddPostTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}
