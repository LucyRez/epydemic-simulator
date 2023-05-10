//
//  CellsView.swift
//  EpidemicSimulator
//
//  Created by Lucy Rez on 10.05.2023.
//

import UIKit

public final class CellsView: UIView {
    
    var delegate: SimulationDelegate?
    
    required init(groupSize: Int) {
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func generateCells(groupSize: Int) {
        var cells: [(CGFloat, CGFloat)] = []
        
        let firstCell = UIView()
        firstCell.backgroundColor = .green
        firstCell.layer.cornerRadius = 7
        firstCell.layer.masksToBounds = true
        
        let x = frame.origin.x
        let y = frame.origin.y
        
        firstCell.frame = CGRect(x: x, y: y, width: 15, height: 15)
        cells.append((x, y))
        addSubview(firstCell)
        
        var size = groupSize
        var lastIndex = 0
        
        while size > 1 {
            let sameXUp: CGPoint = .init(x: cells[lastIndex].0, y: cells[lastIndex].1 - 15)
            let sameXDown: CGPoint = .init(x: cells[lastIndex].0, y: cells[lastIndex].1 + 15)
            let sameYLeft: CGPoint = .init(x: cells[lastIndex].0 - 15, y: cells[lastIndex].1)
            let sameYRight: CGPoint = .init(x: cells[lastIndex].0 + 15, y: cells[lastIndex].1)
            
            if size > 1 && !subviews.contains(where: { $0.frame.contains(sameXUp) }) {
                let cell = UIView()
                cell.backgroundColor = .green
                cell.layer.cornerRadius = 7
                cell.layer.masksToBounds = true
                cell.frame = CGRect(origin: sameXUp, size: .init(width: 15, height: 15))
                cells.append((sameXUp.x, sameXUp.y))
                cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
                addSubview(cell)
                size-=1
            }
            
            if size > 1 && !subviews.contains(where: { $0.frame.contains(sameYLeft) }) {
                let cell = UIView()
                cell.backgroundColor = .green
                cell.layer.cornerRadius = 7
                cell.layer.masksToBounds = true
                cell.frame = CGRect(origin: sameYLeft, size: .init(width: 15, height: 15))
                cells.append((sameYLeft.x, sameYLeft.y))
                cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
                addSubview(cell)
                size-=1
            }
            
            if size > 1 && !subviews.contains(where: { $0.frame.contains(sameXDown) }) {
                let cell = UIView()
                cell.backgroundColor = .green
                cell.layer.cornerRadius = 7
                cell.layer.masksToBounds = true
                cell.frame = CGRect(origin: sameXDown, size: .init(width: 15, height: 15))
                cells.append((sameXDown.x, sameXDown.y))
                cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
                addSubview(cell)
                size-=1
            }
            
            if size > 1 && !subviews.contains(where: { $0.frame.contains(sameYRight) }) {
                let cell = UIView()
                cell.backgroundColor = .green
                cell.layer.cornerRadius = 7
                cell.layer.masksToBounds = true
                cell.frame = CGRect(origin: sameYRight, size: .init(width: 15, height: 15))
                cells.append((sameYRight.x, sameYRight.y))
                cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
                addSubview(cell)
                size-=1
            }
            
            lastIndex += 1
        }

    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        var neighbors: [UIView] = []
        for subview in subviews {
            if  subview.frame.contains(.init(x: location.x + 15, y: location.y)) ||
                subview.frame.contains(.init(x: location.x, y: location.y + 15)) ||
                subview.frame.contains(.init(x: location.x - 15, y: location.y)) ||
                subview.frame.contains(.init(x: location.x, y: location.y - 15)) {
                neighbors.append(subview)
            }
            
            if subview.frame.contains(location) {
                if subview.backgroundColor != .red {
                    subview.backgroundColor = .red
                    delegate?.cellWasInfected(view: subview, neighbors: neighbors)
                }
            }
        }
    }
    
}



