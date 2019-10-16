//
//  PhotoSelectorViewController.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/16/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postImageView.image = nil
        selectImageButton.setTitle("Select Image", for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        imagePickerAlert()
    }

    // Helper Functions
    func updateDesign() {
        postImageView.layer.borderWidth = 1
    }
    
}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImageButton.setTitle("", for: .normal)
            postImageView.image = photo
            delegate?.photoSelectorViewControllerSelected(image: photo)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerAlert() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let pickerAction = UIAlertController(title: "Select A Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerAction.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerAction.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true)
            }))
        }
        pickerAction.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(pickerAction, animated: true)
    }
} // EOE

protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}
