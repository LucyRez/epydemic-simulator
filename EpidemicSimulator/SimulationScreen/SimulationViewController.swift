//
//  SimulationViewController.swift
//  EpidemicSimulator
//
//  Created by Lucy Rez on 10.05.2023.
//

import UIKit

public final class SimulationViewController: UIViewController {
    
    private let simulationService: SimulationService
    private let groupSize: Int
    private var infected: Int = 0
    
    private let statisticsLabel: UILabel = {
        let sl = UILabel()
        sl.font = .systemFont(ofSize: 18, weight: .medium)
        return sl
    }()
    
        
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.minimumZoomScale = 0.7
        scroll.maximumZoomScale = 4.0
        return scroll
    }()
    
    init(groupSize: Int, infectionFactor: Int, timePeriod: Int) {
        simulationService = SimulationService(groupSize: groupSize, infectionFactor: infectionFactor, timePeriod: timePeriod)
        self.groupSize = groupSize
        super.init(nibName: nil, bundle: nil)
        simulationService.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.title = "Simulation Screen"
        scrollView.delegate = self
        setUpView()
    }
    
    private func setUpView() {
        statisticsLabel.text = "Всего: \(groupSize), Инфицировано: \(infected)"
        
        view.addSubview(statisticsLabel)
        statisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let cellView = simulationService.cellView
        cellView.frame = CGRect(origin: .init(x: view.center.x*1.5, y: view.center.y*1.5), size: .init(width: view.frame.width*2, height: view.frame.height*2))
        cellView.generateCells(groupSize: groupSize)
        cellView.frame.origin = .zero
        cellView.frame.size =  .init(width: view.frame.width*2, height: view.frame.height*1.5)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cellView)
        scrollView.contentSize = cellView.frame.size
        
        NSLayoutConstraint.activate([
            statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            statisticsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        scrollView.zoomScale = 0.4
        view.bringSubviewToFront(statisticsLabel)
    }
    
    @objc private func dismissSelf() {
        dismiss (animated: true, completion: nil)
        
    }
    
}

extension SimulationViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return simulationService.cellView
    }
}

extension SimulationViewController: SimulationDelegate {
    func cellWasInfected(view: UIView, neighbors: [UIView]) {
        infected += 1
        statisticsLabel.text = "Всего: \(groupSize), Инфицировано: \(infected)"
    }
}
