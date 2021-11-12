//
//  ViewController.swift
//  Plates
//
//  Created by Shyam Kumar on 9/9/21.
//

import UIKit

class ViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let helloAttr = NSMutableAttributedString(string: "Hello, ", attributes: thinAttributes)
        let nameAttr = NSMutableAttributedString(string: "Chelsea", attributes: boldAttributes)
        
        helloAttr.append(nameAttr)
        label.attributedText = helloAttr
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let thinAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.light.withSize(30),
        .foregroundColor: UIColor.black
    ]
    
    let boldAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.bold.withSize(30),
        .foregroundColor: UIColor.black
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.3, animations: {
            self.welcomeLabel.alpha = 0
        }, completion: { fin in
            self.performSegue(withIdentifier: "goToApp", sender: self)
        })
    }
    
    func setupView() {
        view.backgroundColor = Colors.offWhite
        view.addSubview(welcomeLabel)
    }
    
    func setupConstraints() {
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }


}

