//
//  YourOrderViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 25/02/2022.
//

import UIKit
import UserNotifications

class YourOrderViewController: UIViewController {

    var menuItems = [MenuItem]()
    var orderMinutes: Int?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Your Order"
  
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if !permissionGranted {
                print("Permission Denied")
            } else {
                
            }
        }
        if let data = UserDefaults.standard.data(forKey: "menuItem") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let menuItem = try decoder.decode(MenuItem.self, from: data)
                menuItems.append(menuItem)

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(didTapSubmit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Track", style: .plain, target: self, action: #selector(didTapTrack))

    }
    
    @objc private func didTapTrack() {
        let vc = OrderTrackViewController()
        
        present(vc, animated: true)
    }
    
    
    private func showAlert(minutes: Int) {
        let alert = UIAlertController(title: "Success", message: "Your order will be ready within \(minutes) minutes" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)

        }
        
        
    }
    
    func uploadOrder() {
        let menuIds = menuItems.map { $0.id }
        APICaller.shared.submitOrder(menuIds: menuIds) { [weak self] (minutes) in
            if let minutes = minutes {
                DispatchQueue.main.async {
                    self?.orderMinutes = minutes
                    let vc = OrderConfirmationViewController()
                    vc.minutes = minutes
                    vc.senderVC = self
                    UserDefaults.standard.set(Date.now.addingTimeInterval(TimeInterval(minutes*60)), forKey: "orderFinishTime")
                    UserDefaults.standard.set(TimeInterval(minutes*60), forKey: "orderDuration")
                    self?.present(vc, animated: true)
                }
            }
        }
    }
    
    func removeAll() {
        menuItems = []
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
        UserDefaults.standard.removeObject(forKey: "menuItem")
        updateBadgeNumber()
    }
    
    @objc private func didTapSubmit() {
        notify()

        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            self.uploadOrder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: { [weak self] in
            self?.notify()
        })
 
    }
    
    func notify() {
        notificationCenter.getNotificationSettings { settings in
            let title = "Order"
            let message = "Your order is ready"
            let date = Date.now + TimeInterval(1 * 10)
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.notificationCenter.add(request) { error in
                    if error != nil {
                        return
                    }
                    
                }
                
                let alert = UIAlertController(title: "Added", message: "Your device will notify", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    

}


extension YourOrderViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: menuItems[indexPath.row].name, imageIndex: menuItems[indexPath.row].id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.removeObject(forKey: "menuItem")
            updateBadgeNumber()
        }
    }
    
    func updateBadgeNumber() {
        let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}


extension YourOrderViewController: AddToOrderDelegate {
    func didAddToOrder(menuItem: MenuItem) {
        
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(menuItem)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "menuItem")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
        
        menuItems.append(menuItem)
        let count = menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        updateBadgeNumber()
    }
    

}
