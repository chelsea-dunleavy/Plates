//
//  CalculateViewController.swift
//  Plates
//
//  Created by Shyam Kumar on 9/9/21.
//

import UIKit

struct CalculateVCModel {
    var weight: Double
    var barWeight: Int
    init(weight: Double = 155, barWeight: Int = 20) {
        self.weight = weight
        self.barWeight = barWeight
    }
}

class CalculateViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var model: CalculateVCModel = CalculateVCModel() {
        didSet {
            updateView()
        }
    }
    
    var isWeightSelected: Bool = false
    var isBarSelected: Bool = false
    
    let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    let selectionGenerator = UISelectionFeedbackGenerator()
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        
        let helloAttr = NSMutableAttributedString(string: "Hello, ", attributes: thinAttributes)
        let nameAttr = NSMutableAttributedString(string: "Chelsea", attributes: boldAttributes)
        
        helloAttr.append(nameAttr)
        label.attributedText = helloAttr
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let thinAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.light.withSize(20),
        .foregroundColor: UIColor.black
    ]
    
    let thinSelectedAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.light.withSize(20),
        .foregroundColor: Colors.blue
    ]
    
    let boldAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.bold.withSize(20),
        .foregroundColor: UIColor.black
    ]
    
    let boldWeightAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.bold.withSize(60),
        .foregroundColor: UIColor.black
    ]
    
    let thinWeightAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.thin.withSize(30),
        .foregroundColor: UIColor.black
    ]
    
    let boldWeightSelectedAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.bold.withSize(60),
        .foregroundColor: Colors.blue
    ]
    
    let thinWeightSelectedAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.thin.withSize(30),
        .foregroundColor: Colors.blue
    ]
    
    lazy var weightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(weightLabel)
        stack.addArrangedSubview(barWeightLabel)
        return stack
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        
        let weightText = NSMutableAttributedString(string: "155", attributes: boldWeightAttributes)
        let weightLabel = NSMutableAttributedString(string: " lbs", attributes: thinWeightAttributes)
        weightText.append(weightLabel)
        label.attributedText = weightText
        label.textAlignment = .center
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(weightLabelTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var barWeightLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.thin.withSize(20)
        label.text = "20 kg bar"
        label.textAlignment = .center
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(barLabelTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var tableView: PlateTableView = {
        let view = PlateTableView()
        view.model = tableViewModel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableViewModel: PlateTableViewModel = {
        return PlateTableViewModel()
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = Colors.offWhite
        view.addSubview(welcomeLabel)
        view.addSubview(weightStack)
        view.addSubview(tableView)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))
        view.addGestureRecognizer(dragGesture)
    }
    
    func setupConstraints() {
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        weightStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        weightStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        weightStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 32).isActive = true
        weightStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.topAnchor.constraint(equalTo: weightStack.bottomAnchor, constant: 24).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
    
    func updateView() {
        if !isWeightSelected {
            setWeightAttributedText(weight: model.weight, boldAttributes: boldWeightAttributes, thinAttributes: thinWeightAttributes)
        } else {
            setWeightAttributedText(weight: model.weight, boldAttributes: boldWeightSelectedAttributes, thinAttributes: thinWeightSelectedAttributes)
        }
        
        if !isBarSelected {
            setBarWeightAttributedText(barWeight: model.barWeight)
        } else {
            setBarWeightAttributedText(barWeight: model.barWeight, color: Colors.blue, font: Fonts.regular.withSize(20))
        }
    }
    
    func setWeightAttributedText(weight: Double, boldAttributes: [NSAttributedString.Key: Any], thinAttributes: [NSAttributedString.Key: Any]) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal
        
        let weightText = NSMutableAttributedString(string: formatter.string(from: weight as NSNumber)!, attributes: boldAttributes)
        let weightLabel = NSMutableAttributedString(string: " lbs", attributes: thinAttributes)
        weightText.append(weightLabel)
        self.weightLabel.attributedText = weightText
    }
    
    func setBarWeightAttributedText(barWeight: Int, color: UIColor = UIColor.black, font: UIFont = Fonts.thin.withSize(20)) {
        barWeightLabel.text = "\(barWeight) kg bar"
        barWeightLabel.textColor = color
        barWeightLabel.font = font
    }
    
    @objc func weightLabelTapped() {
        mediumImpactGenerator.prepare()
        mediumImpactGenerator.impactOccurred()
        isWeightSelected = true
        setWeightAttributedText(weight: model.weight, boldAttributes: boldWeightSelectedAttributes, thinAttributes: thinWeightSelectedAttributes)
        
        if isBarSelected {
            isBarSelected = false
            setBarWeightAttributedText(barWeight: model.barWeight)
        }
    }
    
    @objc func barLabelTapped() {
        mediumImpactGenerator.prepare()
        mediumImpactGenerator.impactOccurred()
        isBarSelected = true
        setBarWeightAttributedText(barWeight: model.barWeight, color: Colors.blue, font: Fonts.regular.withSize(20))
        
        if isWeightSelected {
            isWeightSelected = false
            setWeightAttributedText(weight: model.weight, boldAttributes: boldWeightAttributes, thinAttributes: thinWeightAttributes)
        }
    }
    
    @objc func dragGesture(_ sender: UIPanGestureRecognizer) {
        selectionGenerator.prepare()
        if isWeightSelected {
            let factor = Double((sender.velocity(in: view).x / 100).rounded() * 0.5)
            if model.weight + factor < 0 {
                return
            }
            selectionGenerator.selectionChanged()
            model.weight += factor
            tableViewModel.weight = model.weight
            tableViewModel.updateModel()
            tableView.tableView.reloadData()
            return
        }
        
        if isBarSelected {
            let factor = Int((sender.velocity(in: view).x / 100).rounded())
            if model.barWeight + factor < 0 {
                return
            }
            selectionGenerator.selectionChanged()
            model.barWeight += Int(factor)
            tableViewModel.barWeight = model.barWeight
            tableViewModel.updateModel()
            tableView.tableView.reloadData()
        }
    }
}
