//
//  ViewController.swift
//  CouscousOrNotCouscous
//
//  Created by M'haimdat omar on 13-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import CoreML
import Vision

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "couscous").resized(newSize: CGSize(width: screenWidth - 40, height: (screenWidth - 40)/1.6 )))
        image.translatesAutoresizingMaskIntoConstraints = false
       return image
    }()
    
    let upload: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToUpload(_:)), for: .touchUpInside)
        button.setTitle("Upload an image", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.5137254902, blue: 0.5529411765, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.7098039216, green: 0.5137254902, blue: 0.5529411765, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    let openCamera: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToOpenCamera(_:)), for: .touchUpInside)
        button.setTitle("Take a picture", for: .normal)
        let icon = UIImage(named: "camera")?.resized(newSize: CGSize(width: 50, height: 50))
        button.addRightImage(image: icon!, offset: 30)
        button.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.4078431373, blue: 0.4588235294, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.4274509804, green: 0.4078431373, blue: 0.4588235294, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addSubviews()
        setupLayout()
        
    }
    
    func addSubviews() {
        view.addSubview(logo)
        view.addSubview(upload)
        view.addSubview(openCamera)
    }
    
    func setupLayout() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 60).isActive = true
        
        upload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        upload.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        upload.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        upload.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        openCamera.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openCamera.topAnchor.constraint(equalTo: upload.bottomAnchor, constant: 30).isActive = true
        openCamera.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        openCamera.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else {
                fatalError("Unable to load model")
            }
            let request = VNCoreMLRequest(model: model) {[weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first
                    else {
                        fatalError("Unexpected results")
                }
                
                // Update the main UI thread with our result
                DispatchQueue.main.async {[weak self] in
                    let controller = CouscousImageViewController()
                    controller.couscousImage.image = pickedImage
                    if topResult.identifier == "couscous" {
                        controller.isOrNotCouscous.image = #imageLiteral(resourceName: "isCouscous")
                        self?.present(controller, animated: true)
                    } else {
                        controller.isOrNotCouscous.image = #imageLiteral(resourceName: "isNotCouscous")
                        self?.present(controller, animated: true)
                    }
                }
            }
            
            guard let ciImage = CIImage(image: pickedImage)
                else { fatalError("Cannot read picked image")}
            
            // Run the classifier
            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    @objc func buttonToUpload(_ sender: BtnPleinLarge) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToOpenCamera(_ sender: BtnPleinLarge) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }


}

