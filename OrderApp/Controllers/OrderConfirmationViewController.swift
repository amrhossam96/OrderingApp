//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 27/02/2022.
//

import UIKit


class OrderConfirmationViewController: UIViewController {

    
    var senderVC: UIViewController?
    
    private let confirmationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    var minutes: Int!
    
    private let xmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .secondaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func didTapXMark() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(timeRemainingLabel)
        view.addSubview(confirmationImageView)
        view.addSubview(xmarkButton)
        xmarkButton.addTarget(self, action: #selector(didTapXMark), for: .touchUpInside)
        configureConstraints()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let senderVC = senderVC as? YourOrderViewController else {
            return
        }
        senderVC.removeAll()
    }
    
    private func configureConstraints() {
        let timeRemainingLabelConstraints = [
            timeRemainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeRemainingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            timeRemainingLabel.widthAnchor.constraint(equalToConstant: 350)
        ]
        
        let imageViewConstraints = [
            confirmationImageView.bottomAnchor.constraint(equalTo: timeRemainingLabel.topAnchor, constant: -40),
            confirmationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationImageView.widthAnchor.constraint(equalToConstant: 120),
            confirmationImageView.heightAnchor.constraint(equalToConstant: 120)
        ]
        
        let xmarkButtonConstraints = [
            xmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            xmarkButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ]
        
        
        NSLayoutConstraint.activate(timeRemainingLabelConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(xmarkButtonConstraints)
    }
    
}
