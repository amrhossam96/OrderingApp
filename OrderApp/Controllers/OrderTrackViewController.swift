//
//  OrderTrackViewController.swift
//  OrderApp
//
//  Created by Amr Hossam on 27/02/2022.
//

import UIKit

class OrderTrackViewController: UIViewController {

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.text = "00:02:42"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let orderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "Your Order will be ready in"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .gray
        progress.progress = 0.5
        return progress
    }()
    
    var time: Int!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(orderTimeLabel)
        view.addSubview(timerLabel)
        view.addSubview(progressBar)
        configureConstraints()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)

    }
    
    @objc private func updateView() {
        let finishingDate = UserDefaults.standard.object(forKey: "orderFinishTime") as! Date
        guard let timer = timer else {
            return
        }
        let duration = UserDefaults.standard.object(forKey: "orderDuration") as! Double

        
        let timeRemaining = Int(abs(Date().timeIntervalSince(finishingDate)))
        if timeRemaining < 0 {
            timer.invalidate()
        }
        
        progressBar.setProgress(Float(Double(timeRemaining) / duration), animated: true)
        let tuple = secondsToHoursMinutesSeconds(timeRemaining)
        let hr = String(format: "%02d", tuple.0)
        let min = String(format: "%02d", tuple.1)
        let sec = String(format: "%02d", tuple.2)
        timerLabel.text = "\(hr):\(min):\(sec)"
        
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func configureConstraints() {
        let orderTimeLabelConstraints = [
            orderTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            orderTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orderTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            orderTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ]
        
        let timerLabelConstraints = [
            timerLabel.topAnchor.constraint(equalTo: orderTimeLabel.bottomAnchor, constant: 30),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let progressBarConstraints = [
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: timerLabel.bottomAnchor,constant: 30),
            progressBar.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            progressBar.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        
        NSLayoutConstraint.activate(orderTimeLabelConstraints)
        NSLayoutConstraint.activate(timerLabelConstraints)
        NSLayoutConstraint.activate(progressBarConstraints)
    }
}
