//
//  MenuItemDetailsViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import UIKit
import CoreData


protocol AddToOrderDelegate: AnyObject {
    func didAddToOrder(menuItem: MenuItem)
}

class MenuItemDetailsViewController: UIViewController {

    weak var delegate: AddToOrderDelegate?
    var menuItem: MenuItem?
    private var itemCount = 1
    weak var fromContext: UIViewController?
    
    
    private let menuItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "drink")
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let categoryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var blurredVisualEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.text = "Description"
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        return stepper
    }()
    
    private lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let addToOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to order", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let xmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(foodImageView)
        view.addSubview(blurredVisualEffect)
        view.addSubview(descriptionLabel)
        view.addSubview(detailsLabel)
        view.addSubview(priceLabel)
        view.addSubview(stepper)
        view.addSubview(itemCountLabel)
        view.addSubview(totalLabel)
        view.addSubview(addToOrderButton)
        view.addSubview(xmarkButton)
        blurredVisualEffect.contentView.addSubview(menuItemLabel)
        blurredVisualEffect.contentView.addSubview(categoryTextLabel)
        configureConstraints()
        updateUI()
        setupDelegate()

        xmarkButton.addTarget(self, action: #selector(didTapXMark), for: .touchUpInside)
        
        stepper.addAction(UIAction(handler: { action in
            self.itemCountLabel.text = "\(String(describing: self.menuItemLabel.text!)) x\(Int(self.stepper.value))"
            self.totalLabel.text = "Total: $\(String(describing: (self.menuItem!.price) * self.stepper.value))"
            self.itemCount += 1
        }), for: .valueChanged)
        
        view.round(corners: [.topRight,.topLeft], radius: 30)
        
        addToOrderButton.addTarget(self, action: #selector(didTapAddToOrder), for: .touchUpInside)
        
        
    }
    
    private func setupDelegate() {

        guard let fromContext = fromContext else {
            return
        }

        if let navController = fromContext.tabBarController?.viewControllers?.last as? UINavigationController,
           let orderTableViewController = navController.viewControllers.first as? YourOrderViewController {
            delegate = orderTableViewController

        }
        
    }
    
    @objc private func didTapAddToOrder() {
        UIView.animate(withDuration: 0.7, delay: 0,
               usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1,
               options: [], animations: {
                self.addToOrderButton.transform =
            CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.addToOrderButton.transform =
                   CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {_ in
        })
        

    
        

        guard let menuItem = menuItem else {
            return
        }

        delegate?.didAddToOrder(menuItem: menuItem)
        
    }
    
    @objc private func didTapXMark() {
        dismiss(animated: true)
    }
    
    private func updateUI() {
        menuItemLabel.text = menuItem?.name
        categoryTextLabel.text = menuItem?.category
        detailsLabel.text = menuItem?.detailText
        priceLabel.text = "$\(menuItem!.price)"
        itemCountLabel.text = "\(String(describing: self.menuItemLabel.text!)) x\(itemCount)"
        totalLabel.text = "Total: $\(String(describing: menuItem!.price))"
   
        foodImageView.image = UIImage(named: "0\(menuItem!.id)")
    }

    
    private func configureConstraints() {
        let foodImageViewConstraints = [
            foodImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2),
            foodImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: 500)
        ]
        
        let blurredVisualEffectConstraints = [
            blurredVisualEffect.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredVisualEffect.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredVisualEffect.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor),
            blurredVisualEffect.heightAnchor.constraint(equalToConstant: 140)
        ]
        

        
        let menuItemLabelConstraints = [
            menuItemLabel.leadingAnchor.constraint(equalTo: blurredVisualEffect.leadingAnchor, constant: 20),
            menuItemLabel.topAnchor.constraint(equalTo: blurredVisualEffect.topAnchor, constant: 20),
            menuItemLabel.widthAnchor.constraint(equalToConstant: 220)
        ]
        
        let detailsTextLabelConstraints = [
            categoryTextLabel.leadingAnchor.constraint(equalTo: blurredVisualEffect.leadingAnchor, constant: 20),
            categoryTextLabel.topAnchor.constraint(equalTo: menuItemLabel.bottomAnchor, constant: 10),
            categoryTextLabel.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: blurredVisualEffect.bottomAnchor, constant: 20)
        ]
        
        let detailsLabelConstraints = [
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15)
        ]
        
        let priceLabelConstraints = [
            priceLabel.trailingAnchor.constraint(equalTo: blurredVisualEffect.trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: blurredVisualEffect.topAnchor, constant: 20)
        ]
        
        let stepperConstraints = [
            stepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stepper.centerYAnchor.constraint(equalTo: itemCountLabel.centerYAnchor)
        ]
        
        let itemCountLabelConstraints = [
            itemCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemCountLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 25),
            itemCountLabel.widthAnchor.constraint(equalToConstant: 250)
        ]
        
        
        let totalLabelConstraints = [
            totalLabel.leadingAnchor.constraint(equalTo: itemCountLabel.leadingAnchor),
            totalLabel.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 20)
        ]
        
        let addToOrderButtonConstraints = [
            addToOrderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addToOrderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addToOrderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addToOrderButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let xmarkButtonConstraints = [
            xmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            xmarkButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(foodImageViewConstraints)
        NSLayoutConstraint.activate(blurredVisualEffectConstraints)
        NSLayoutConstraint.activate(menuItemLabelConstraints)
        NSLayoutConstraint.activate(detailsTextLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(detailsLabelConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
        NSLayoutConstraint.activate(stepperConstraints)
        NSLayoutConstraint.activate(itemCountLabelConstraints)
        NSLayoutConstraint.activate(totalLabelConstraints)
        NSLayoutConstraint.activate(addToOrderButtonConstraints)
        NSLayoutConstraint.activate(xmarkButtonConstraints)

    }
}

