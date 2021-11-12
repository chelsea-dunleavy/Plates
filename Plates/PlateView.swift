//
//  PlateView.swift
//  Plates
//
//  Created by Shyam Kumar on 9/11/21.
//

import UIKit

struct PlateViewModel {
    var weight: Double
    var width: Double
    var backgroundColor: UIColor
    
    init(weight: Double = 5, width: Double = 50, backgroundColor: UIColor = .red) {
        self.weight = weight
        self.width = width
        self.backgroundColor = backgroundColor
    }
}

class PlateView: UIView {
    var model: PlateViewModel = PlateViewModel() {
        didSet {
            updateView(model: model)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var plateWidth: NSLayoutConstraint?
    var plateHeight: NSLayoutConstraint?
    
    lazy var plate: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = model.backgroundColor
        view.layer.cornerRadius = CGFloat(model.width / 2)
        plateWidth = view.heightAnchor.constraint(equalToConstant: CGFloat(model.width))
        plateHeight = view.widthAnchor.constraint(equalToConstant: CGFloat(model.width))
        
        plateHeight?.isActive = true
        plateWidth?.isActive = true
        return view
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thinAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.light.withSize(20),
        .foregroundColor: UIColor.black
    ]
    
    let boldAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.regular.withSize(20),
        .foregroundColor: UIColor.black
    ]
    
    func setupView() {
        addSubview(plate)
        addSubview(weightLabel)
    }
    
    func setupConstraints() {
        plate.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plate.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
//        weightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        weightLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weightLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView(model: PlateViewModel) {
        plateHeight?.constant = CGFloat(model.width)
        plateWidth?.constant = CGFloat(model.width)
        plate.layer.cornerRadius = CGFloat(model.width / 2)
        plate.backgroundColor = model.backgroundColor
        updateWeightLabel(kg: model.weight)
    }
    
    func updateWeightLabel(kg: Double) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        
        let weightString = NSMutableAttributedString(string: formatter.string(from: kg as NSNumber)!, attributes: boldAttributes)
        let label = NSMutableAttributedString(string: " kg", attributes: thinAttributes)
        weightString.append(label)
        
        weightLabel.attributedText = weightString
    }
}
