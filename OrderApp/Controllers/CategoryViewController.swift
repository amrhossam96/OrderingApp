//
//  MenuViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    
    var categories = [String]()

    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.title = "Restaurant"
        view.addSubview(categoryTableView)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        fetchCategories()
    }
    
    
    private func fetchCategories() {
        APICaller.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.updateUI(with: categories)
            case .failure(let error):
                self.displayError(error,
                                   title: "Failed to Fetch Categories")
                
            }
        }
    }
    
    func updateUI(with categories: [String]) {
            DispatchQueue.main.async {
                self.categories = categories
                self.categoryTableView.reloadData()
            }
        }
    
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title,
                   message: error.localizedDescription,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss",
                   style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryTableView.frame = view.frame
    }
}



extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: categories[indexPath.row], imageIndex: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MenuViewController()
        vc.category = categories[indexPath.row]
        
        vc.title = categories[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    


}
