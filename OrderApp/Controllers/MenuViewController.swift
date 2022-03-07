//
//  MenuViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import UIKit

class MenuViewController: UIViewController {

    
    var category: String?
    private var menuItems: [MenuItem] = [MenuItem]()
    
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()
    

    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(menuTableView)
        menuTableView.dataSource = self
        menuTableView.delegate = self
        fetchMenuItems()
        

    }

    
    private func fetchMenuItems() {
        guard let category = category else {
            return
        }

        APICaller.shared.fetchMenuItems(forCategory: category) { result in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items for \(category)")

            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuTableView.frame = view.frame
    }
    
    
    
    func updateUI(with menuItems: [MenuItem]) {
            DispatchQueue.main.async {
                self.menuItems = menuItems
                self.menuTableView.reloadData()
            }
        }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message:
               error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style:
               .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: menuItems[indexPath.row].name, imageIndex: Int(menuItems[indexPath.row].id))

        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = MenuItemDetailsViewController()
        vc.fromContext = self
        vc.menuItem = menuItems[indexPath.row]
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
