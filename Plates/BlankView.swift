//
//  BlankView.swift
//  Plates
//
//  Created by Shyam Kumar on 9/11/21.
//

import UIKit

class BlankView: UIView {
    
    lazy var fillerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        addSubview(fillerView)
    }
    
    func setupConstraints() {
        fillerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fillerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        fillerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        fillerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
