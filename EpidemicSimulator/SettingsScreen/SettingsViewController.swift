//
//  ViewController.swift
//  EpidemicSimulator
//
//  Created by Lucy Rez on 09.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var groupSize: SettingView = {
        let sv = SettingView(title: "Размер группы", placeholderText: "от 5 до 500", errorText: "Число должно быть от 5 до 500", minValue: 5, maxValue: 500)
        return sv
    }()
    
    private var infectionFactor: SettingView = {
        let sv = SettingView(title: "Фактор распространения", placeholderText: "от 1 до 8", errorText: "Число должно быть от 1 до 8", minValue: 1, maxValue: 8)
        return sv
    }()
    
    private var timePeriod: SettingView = {
        let sv = SettingView(title: "Период пересчета", placeholderText: "от 1 до 60", errorText: "Число должно быть от 1 до 60", minValue: 1, maxValue: 60)
        return sv
    }()
    
    private lazy var nextScreenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Запустить симуляцию", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(goToSimulationScreen), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(groupSize)
        view.addSubview(infectionFactor)
        view.addSubview(timePeriod)
        view.addSubview(nextScreenButton)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            groupSize.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            groupSize.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupSize.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            groupSize.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            infectionFactor.topAnchor.constraint(equalTo: groupSize.bottomAnchor, constant: 16),
            infectionFactor.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            infectionFactor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infectionFactor.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            timePeriod.topAnchor.constraint(equalTo: infectionFactor.bottomAnchor, constant: 16),
            timePeriod.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            timePeriod.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePeriod.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            nextScreenButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            nextScreenButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc private func goToSimulationScreen() {
        if let groupSize = groupSize.value, let infectFactor = infectionFactor.value, let timePeriod = timePeriod.value {
            let root = SimulationViewController(groupSize: groupSize, infectionFactor: infectFactor, timePeriod: timePeriod)
            let navigationVC = UINavigationController(rootViewController: root)
            navigationVC.modalPresentationStyle = .fullScreen
            present(navigationVC, animated: false)
        }
        
        return
    }


}

