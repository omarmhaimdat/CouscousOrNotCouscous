//
//  CouscousImageViewController.swift
//  CouscousOrNotCouscous
//
//  Created by M'haimdat omar on 13-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class CouscousImageViewController: UIViewController {
    
    let isOrNotCouscous: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "isNotCouscous"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    let couscousImage: UIImageView = {
       let image = UIImageView(image: UIImage())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let dissmissButton: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        view.addSubview(dissmissButton)
        view.addSubview(couscousImage)
        view.addSubview(isOrNotCouscous)
    }
    
    func setupLayout() {
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        couscousImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        couscousImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        couscousImage.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        isOrNotCouscous.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        isOrNotCouscous.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        isOrNotCouscous.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        isOrNotCouscous.heightAnchor.constraint(equalToConstant: 217).isActive = true
        
    }
    
    @objc func buttonToDissmiss(_ sender: BtnPleinLarge) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
