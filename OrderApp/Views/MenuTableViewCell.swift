//
//  MenuTableViewCell.swift
//  OrderApp
//
//  Created by Amr Hossam on 26/02/2022.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static let identifier = "MenuTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let itemTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(iconImageView)
        contentView.addSubview(itemTextLabel)
        configureConstraints()
    }
    
    func configure(with model: String, imageIndex: Int) {
        itemTextLabel.text = model.capitalized
        iconImageView.image = UIImage(named: "0\(imageIndex)")
    }
    
    private func configureConstraints() {
        
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let itemTextLabelConstraints = [
            itemTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            itemTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(itemTextLabelConstraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
