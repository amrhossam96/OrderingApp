//
//  CustomTableViewCell.swift
//  OrderApp
//
//  Created by Amr Hossam on 26/02/2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configure(with model: String, imageIndex: IndexPath) {
        itemTextLabel.text = model.capitalized
        iconImageView.image = UIImage(named: "\(imageIndex.row)")
    }
    
    private func configureConstraints() {
        
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60)
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
