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
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        // Set upright Confirm button
        let confirmButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.on.square"), style: .plain, target: self, action: #selector(confirmButtonTapped))
        
        // Undo button
        let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward.circle"), style: .plain, target: self, action: #selector(undoTapped))
        
        // Redo button
        let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward.circle"), style: .plain, target: self, action: #selector(redoTapped))
        
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
        
        //present(PreviewViewController(image: image), animated: true)
        navigationController?.pushViewController(PreviewViewController(image: image), animated: true)
    }
    
    @objc private func undoTapped() {
        canvasView.undoManager?.undo()
    }

    @objc private func redoTapped() {
        canvasView.undoManager?.redo()
    }
}
