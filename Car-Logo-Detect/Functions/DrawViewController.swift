//
//  DrawViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/13.
//

import Foundation
import UIKit
import PencilKit

class DrawViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    private lazy var canvasView = PKCanvasView()
    private lazy var toolPicker = PKToolPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupNavigationBar()
        setupViews()
        view.backgroundColor = .white
    }
    
    private func setupCanvas() {
        canvasView.delegate = self
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    
    private func setupNavigationBar() {
        // Set title of the navigation bar
        title = "Drawing Board"
        
        // Set upleft back button
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        
        // Set upright Confirm button
        let confirmButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmButtonTapped))
        
        // Undo button
        let undoButton = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(undoTapped))
        
        // Redo button
        let redoButton = UIBarButtonItem(title: "Redo", style: .plain, target: self, action: #selector(redoTapped))
        
        navigationItem.leftBarButtonItems = [backButton, confirmButton] // Order: Back -> Confirm
        navigationItem.rightBarButtonItems = [redoButton, undoButton] // Order: Redo -> Undo
    }

    private func setupViews() {
        view.addSubview(canvasView)

        canvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        // Generate UIImage from PKCanvasView's drawing property
        let drawing = canvasView.drawing
        let image = drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        
        present(PreviewViewController(image: image), animated: true)
    }
    
    @objc private func undoTapped() {
        canvasView.undoManager?.undo()
    }

    @objc private func redoTapped() {
        canvasView.undoManager?.redo()
    }
}
