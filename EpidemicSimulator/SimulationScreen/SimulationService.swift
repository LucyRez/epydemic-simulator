//
//  SimulationService.swift
//  EpidemicSimulator
//
//  Created by Lucy Rez on 10.05.2023.
//

import UIKit

public final class SimulationService {
    
    private let groupSize: Int
    private let infectionFactor: Int
    private let timePeriod: Int
    private var timer: Timer = Timer()
    private let calculations = DispatchQueue.global(qos: .userInitiated)
    
    public let cellView: CellsView
    private var infectedCells: [UIView: [UIView]] = [:]
    var delegate: SimulationDelegate?
    
    init(groupSize: Int, infectionFactor: Int, timePeriod: Int) {
        self.groupSize = groupSize
        self.infectionFactor = infectionFactor
        self.timePeriod = timePeriod
        cellView = CellsView(groupSize: groupSize)
        cellView.delegate = self
        startInfectionTimer()
    }
    
    private func startInfectionTimer() {
        calculations.async { [weak self] in
            self?.timer = Timer(timeInterval: TimeInterval(self?.timePeriod ?? 1), repeats: true) { [weak self] _ in
                var infected: [UIView] = []
                    self?.infectedCells.forEach { cell in
                        let needToInfect = Int.random(in: 1...(self?.infectionFactor ?? 1))
                        self?.infectedCells[cell.key]?.forEach { neighbor in
                            if needToInfect != infected.count && neighbor.backgroundColor != .red {
                                infected.append(neighbor)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        for infect in infected {
                            var neighbors = [UIView]()
                            
                            self?.cellView.subviews.forEach { subview in
                                if  subview.frame.contains(.init(x: infect.frame.minX + 15, y: infect.frame.minY)) ||
                                        subview.frame.contains(.init(x: infect.frame.minX, y: infect.frame.minY + 15)) ||
                                        subview.frame.contains(.init(x: infect.frame.minX - 15, y: infect.frame.minY)) ||
                                        subview.frame.contains(.init(x: infect.frame.minX, y: infect.frame.minY - 15)) {
                                    neighbors.append(subview)
                                }
                            }

                            infect.backgroundColor = .red
                            self?.delegate?.cellWasInfected(view: infect, neighbors: [])
                            self?.infectedCells[infect] = neighbors
                        }
                    }
                }
            let runLoop = RunLoop.current
            guard let timer = self?.timer else { return }
            runLoop.add(timer, forMode: .default)
                runLoop.run()
            }
    }
    
}

extension SimulationService: SimulationDelegate {
    func cellWasInfected(view: UIView, neighbors: [UIView]) {
        infectedCells[view] = neighbors
        delegate?.cellWasInfected(view: view, neighbors: neighbors)
    }
}

protocol SimulationDelegate {
    func cellWasInfected(view: UIView, neighbors: [UIView])
}
