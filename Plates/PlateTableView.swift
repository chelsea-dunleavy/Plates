//
//  PlateTableView.swift
//  Plates
//
//  Created by Shyam Kumar on 9/11/21.
//

import UIKit

class PlateTableViewModel {
    var weight: Double
    var barWeight: Int
    var plates: [Double] = []
    var cells: [PlateTableViewCellModel] = []
    
    init(weight: Double = 155, barWeight: Int = 20) {
        self.weight = weight
        self.barWeight = barWeight
        weightToCells()
    }
    
    func weightToCells() {
        let kgs = lbsToKg(lbs: weight)
        kgsToPlates(kgs: (kgs - Double(barWeight)) / 2)
        platesToCells()
    }
    
    func lbsToKg(lbs: Double) -> Double {
        return (lbs * 0.45359237)
    }
    
    func kgsToPlates(kgs: Double) {
        let plateSizes: [Double] = [25, 20, 15, 10, 5, 2.5, 1.25]
        for plate in plateSizes {
            if kgs - plate > 0 {
                plates.append(plate)
                kgsToPlates(kgs: kgs - plate)
                return
            } else if kgs - plate == 0 {
                plates.append(plate)
                return
            }
        }
    }
    
    func platesToCells() {
        var plateViews: [PlateViewModel] = []
        for plate in plates {
            let cellSize = max(75 * (plate / 25), 30)
            let color = weightToBackgroundColor(weight: plate)
            plateViews.append(PlateViewModel(weight: plate, width: cellSize, backgroundColor: color))
        }
        
        while plateViews.count > 0 {
            let platesForCell = plateViews.prefix(3)
            cells.append(PlateTableViewCellModel(platesArr: Array(platesForCell)))
            if plateViews.count >= 3 {
                plateViews.removeFirst(3)
            } else {
                return
            }
        }
    }
    
    func weightToBackgroundColor(weight: Double) -> UIColor {
        switch weight {
        case 25:
            return Colors.red
        case 20:
            return Colors.blue
        case 15:
            return Colors.yellow
        case 10:
            return Colors.green
        case 5:
            return Colors.plateWhite
        case 2.5:
            return Colors.red
        case 1.25:
            return Colors.blue
        default:
            return Colors.plateWhite
        }
    }
    
    func updateModel() {
        plates = []
        cells = []
        weightToCells()
    }
}

class PlateTableView: UIView {
    
    var model: PlateTableViewModel = PlateTableViewModel() {
        didSet {
            updateView(model: model)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlateTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView(model: PlateTableViewModel) {
        tableView.reloadData()
    }
}

extension PlateTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PlateTableViewCell {
            cell.model = model.cells[indexPath.item]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        158
    }
}

struct PlateTableViewCellModel {
    var platesArr: [PlateViewModel]
    
    init(platesArr: [PlateViewModel] = []) {
        self.platesArr = platesArr
    }
}

class PlateTableViewCell: UITableViewCell {
    
    var model: PlateTableViewCellModel = PlateTableViewCellModel() {
        didSet {
            updateView(model: model)
        }
    }
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func updateView(model: PlateTableViewCellModel) {
        for plate in model.platesArr {
            let view = PlateView()
            view.model = plate
            stack.addArrangedSubview(view)
        }
        
        let diff = 3 - model.platesArr.count
        
        for _ in 0..<diff {
            stack.addArrangedSubview(BlankView())
        }
    }
    
    override func prepareForReuse() {
        for view in stack.arrangedSubviews { view.removeFromSuperview() }
    }
}
