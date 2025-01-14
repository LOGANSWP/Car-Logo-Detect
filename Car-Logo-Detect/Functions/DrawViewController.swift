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
        canvasView.delegate = self
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        setupNavigationBar()
        setupViews()
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        // 设置标题
        title = "Drawing Board"
        
        // 设置左侧返回按钮
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // 设置右侧保存按钮
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupViews() {
        view.addSubview(canvasView)
        
        canvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        // 返回上一级界面
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        // 处理保存图画逻辑
        print("Save button tapped")
    }
}
