//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Gabriella Seaman on 4/16/23.
//

import UIKit

class DrawingView: UIView {

    var lineWidth: CGFloat = 5
    var lines: [Line] = []
    
    init() {
            super.init(frame: .zero)
            backgroundColor = UIColor.white
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func draw(_ rect: CGRect) {
        for line in lines {
                let path = UIBezierPath()
                path.move(to: line.start)
                path.addLine(to: line.end)
                line.color.setStroke()
                path.lineWidth = line.width // Use the width property of the line
                path.stroke()
            }
    }

    func drawLine(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = line.width
        path.lineCapStyle = .round
        path.move(to: line.start)
        path.addLine(to: line.end)
        line.color.setStroke()
        path.stroke()
    }

    func addLine(_ line: Line) {
        lines.append(line)
        setNeedsDisplay()
    }

    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
}

struct Line {
    var start: CGPoint
    var end: CGPoint
    var color: UIColor
    var width: CGFloat
}



