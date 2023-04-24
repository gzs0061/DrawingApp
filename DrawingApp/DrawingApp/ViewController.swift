//
//  ViewController.swift
//  DrawingApp
//
//  Created by Gabriella Seaman on 4/16/23.
//

import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    let drawingView = DrawingView()
    var currentLine: Line?
    var undoLines = [Line]()
    var currentColor = UIColor.black
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
       
       override var shouldAutorotate: Bool {
           return false
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(drawingView)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawingView.topAnchor.constraint(equalTo: view.topAnchor),
            drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // undo button
        let undoButton = UIButton(type: .system)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        // clear button
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        // color well
        let colorWell = UIColorWell(frame: .zero)
        colorWell.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        colorWell.selectedColor = currentColor
        view.addSubview(colorWell)
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorWell.widthAnchor.constraint(equalToConstant: 40),
            colorWell.heightAnchor.constraint(equalToConstant: 40),
            colorWell.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -20),
            colorWell.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // increase line
        let increaseButton = UIButton(type: .system)
        increaseButton.setTitle("+", for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseWidth), for: .touchUpInside)
        view.addSubview(increaseButton)
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            increaseButton.widthAnchor.constraint(equalToConstant: 40),
            increaseButton.heightAnchor.constraint(equalToConstant: 40),
            increaseButton.trailingAnchor.constraint(equalTo: colorWell.leadingAnchor, constant: -20),
            increaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // decrease line
        let decreaseButton = UIButton(type: .system)
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseWidth), for: .touchUpInside)
        view.addSubview(decreaseButton)
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decreaseButton.widthAnchor.constraint(equalToConstant: 40),
            decreaseButton.heightAnchor.constraint(equalToConstant: 40),
            decreaseButton.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -20),
            decreaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        
    }
    
    @objc func colorWellValueChanged(_ sender: UIColorWell) {
        currentColor = sender.selectedColor!
        }
    
    
    
    @objc func undoButtonTapped() {
        if let lastLine = drawingView.lines.last {
            undoLines.append(lastLine)
            drawingView.lines.removeLast()
            drawingView.setNeedsDisplay()
        }
    }
    
    @objc func clearButtonTapped() {
        undoLines = drawingView.lines
        drawingView.lines = []
        drawingView.setNeedsDisplay()
    }
    
    @objc func increaseWidth() {
        drawingView.lineWidth += 1
    }

    @objc func decreaseWidth() {
        drawingView.lineWidth -= 1
    }

    
}



extension ViewController {
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
        currentLine = Line(start: location, end: location, color: currentColor, width: drawingView.lineWidth)
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
        if var line = currentLine {
            line.end = location
            line.color = currentColor // update line color
            drawingView.addLine(line)
            currentLine = line
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
        if var line = currentLine {
            line.end = location
            line.color = currentColor // update line color
            drawingView.addLine(line)
            currentLine = nil
        }
    }

    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLine = nil
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        currentColor = viewController.selectedColor
        if let colorPickerButton = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
            colorPickerButton.backgroundColor = currentColor
        }
    }
}






