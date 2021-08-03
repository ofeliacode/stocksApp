//
//  StockDetailTableViewCell.swift
//  StocksApp
//
//  Created by Офелия on 27.06.2021.
//

import UIKit

class StockDetailTableViewCell: UITableViewCell {

    
    static let detailCell = "detailCell"
    static let cellHeight: CGFloat = 85
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var amountLb: UILabel = {
        let label = UILabel()
      //  label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLb: UILabel = {
        let label = UILabel()
       // label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var volumeLb: UILabel = {
        let label = UILabel()
      //  label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLb, volumeLb, amountLb])
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 7
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
           stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
           stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(_ model: Stock, index: Int){
        amountLb.text = "Amount: " + String(model.price?.amount ?? 0)
        volumeLb.text = "Volume: " + String(model.volume )
        nameLb.text = "Name: " + model.name
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
