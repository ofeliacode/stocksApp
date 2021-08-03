//
//  TableViewCell.swift
//  StocksApp
//
//  Created by Офелия on 25.06.2021.
//

import UIKit
import CoreData

class StockTableViewCell: UITableViewCell {
    
    static let cellId = "cellId"
    static let cellHeight: CGFloat = 85
    
    var didFavoriteTapped: (() -> Void)?
    
    //MARK: - setup UI elemnts through code
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameCurrency, selectiveBtn])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var stack2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stack, volumeCurrency])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 7
        return stackView
    }()
    
    lazy var leftSideStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolImage, stack2])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var rightSideStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [amountCurrency, percentchangeLb])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .trailing
        return stackView
    }()
    
    lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftSideStack, rightSideStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 21
        return stackView
    }()
    
    lazy var viewBg: UIView = {
        let myNewView = UIView()
        myNewView.translatesAutoresizingMaskIntoConstraints = false
        myNewView.backgroundColor = #colorLiteral(red: 0.9423300028, green: 0.9574193358, blue: 0.9698819518, alpha: 1)
        myNewView.layer.cornerRadius = 15
        return myNewView
    }()
    
    lazy var symbolImage: UIImageView = {
        let theImageView = UIImageView()
        theImageView.image = UIImage(named: "stock")
        theImageView.contentMode = .scaleAspectFit
        theImageView.clipsToBounds = true
        theImageView.layer.borderWidth = 1
        theImageView.layer.borderColor = UIColor.black.cgColor
        theImageView.layer.cornerRadius = 8
        return theImageView
    }()
    
    lazy var amountCurrency: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var volumeCurrency: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.font = UIFont(name: "Montserrat-SemiBold", size: 11.0)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var nameCurrency: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 18, weight: .bold)
        label.font = UIFont(name: "Montserrat-Bold", size: 18.0)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var percentchangeLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12.0)
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var selectiveBtn: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor.systemYellow
        button.addTarget(self, action: #selector(addInFavorites), for: .touchUpInside)
        return button
    }()
    
    @objc func addInFavorites() {
        didFavoriteTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameCurrency.text = nil
        symbolImage.image = nil
        percentchangeLb.text = nil
        volumeCurrency.text = nil
        amountCurrency.text = nil
        symbolImage.image = nil
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewBg.addSubview(mainStack)
        contentView.addSubview(viewBg)
        
        NSLayoutConstraint.activate([
           mainStack.leadingAnchor.constraint(equalTo:  viewBg.leadingAnchor, constant: 10),
           mainStack.trailingAnchor.constraint(equalTo:  viewBg.trailingAnchor, constant: -10),
           mainStack.centerYAnchor.constraint(equalTo:  viewBg.centerYAnchor),

            selectiveBtn.widthAnchor.constraint(equalToConstant: 20),
            selectiveBtn.heightAnchor.constraint(equalToConstant: 20),
            symbolImage.widthAnchor.constraint(equalToConstant: 60),
            symbolImage.heightAnchor.constraint(equalToConstant: 60),
            
            viewBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewBg.trailingAnchor.constraint( equalTo: contentView.trailingAnchor),
            viewBg.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ model: Stock, index: Int) {
        let urlStr = URL(string: "https://storage.googleapis.com/iex/api/logos/\(model.symbol).png")!
        nameCurrency.text = model.name
        amountCurrency.text = "$" + String(model.price?.amount ?? 0)
        volumeCurrency.text = String(model.volume)
        percentchangeLb.text = String(model.percentChange) + "%"

        if index % 2 != 0 {
            viewBg.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9568627451, blue: 0.968627451, alpha: 1)
        } else {
            viewBg.backgroundColor = .white
        }
        
        if String(model.percentChange).first == "-" {
            percentchangeLb.textColor = .red
        } else {
            percentchangeLb.textColor = .systemGreen
        }
        selectiveBtn.isSelected = model.isFavorite ?? false
        symbolImage.loadImageWithURL(urlStr, completion: { image in
            self.symbolImage.image = image
            
        })
    }
    //setup for Favourite vc
    func configure(_ model: StockBD, index: Int) {
        let urlStr = URL(string: "https://storage.googleapis.com/iex/api/logos/\(model.symbol ?? "").png")!
        nameCurrency.text = model.name
        amountCurrency.text = "$\(model.amount )"
        percentchangeLb.text = "\(model.percentChange )" + "%"
        volumeCurrency.text =  String(describing: model.volume)
        selectiveBtn.isSelected = true
        symbolImage.loadImageWithURL(urlStr, completion: { image in
            self.symbolImage.image = image
            
        })
        if index % 2 != 0 {
            viewBg.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9568627451, blue: 0.968627451, alpha: 1)
        } else {
            viewBg.backgroundColor = .white
        }
        
        if "\(model.percentChange)".first == "-" {
            percentchangeLb.textColor = .red
        } else {
            percentchangeLb.textColor = .systemGreen
        }
    }
}
