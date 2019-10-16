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
    var selectedImage: UIImage?
    
    // MARK: - Outlets
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var addPostButton: UIButton!
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        designViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = ""
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func tapGestureRecognizer(_ sender: Any) {
        self.captionTextField.resignFirstResponder()
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let postCaption = captionTextField.text,
            !postCaption.isEmpty,
            let image = selectedImage
            else { return }
        
        PostController.shared.createPostWith(image: image, caption: postCaption) { (post) in
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectorVC" {
            let photoSelector = segue.destination as? PhotoSelectorViewController
            photoSelector?.delegate = self
        }
    }
    
    // MARK: - Helper Functions
    func designViews() {
        addPostButton.layer.cornerRadius = 5
        captionTextField.layer.cornerRadius = 0.5
    }
    
}

extension AddPostTableViewController: PhotoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}

extension AddPostTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        captionTextField.resignFirstResponder()
        return true
    }
}
