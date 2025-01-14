//
//  DrawViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/13.
//

import Foundation
import UIKit

class DrawViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        // 设置标题
        title = "Draw"
        
        // 设置左侧返回按钮
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // 设置右侧保存按钮
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
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
