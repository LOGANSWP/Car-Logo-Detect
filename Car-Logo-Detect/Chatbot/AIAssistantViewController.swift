//
//  AIAssistantViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/27.
//

import Foundation
import UIKit
import MessengerKit

class AIAssistantViewController: MSGMessengerViewController {
    // Users in the chat
    let steve = User(displayName: "Steve", avatar: nil, avatarUrl: nil, isSender: true)
    
    let tim = User(displayName: "Tim", avatar: nil, avatarUrl: nil, isSender: false)
    
    // Messages
    lazy var messages: [[MSGMessage]] = {
        return [
            [
                MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: tim, sentAt: Date()),
            ],
            [
                MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: steve, sentAt: Date()),
                MSGMessage(id: 3, body: .text("Okay ready when you are"), user: steve, sentAt: Date())
            ]
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        dataSource = self
    }
    
    // Override the inputViewPrimaryActionTriggered to simulate Tim sending a message
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        // Get the message text entered by the user (Tim in this case)
        let messageText = inputView.message
        guard !messageText.isEmpty else { return }

        // Create a new message by Tim
        let steveMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(messageText), user: steve, sentAt: Date())

        // Insert the new message into the conversation
        insert(steveMessage)
    }
    
    override func insert(_ message: MSGMessage) {
        collectionView.performBatchUpdates({
            // Check if the message belongs to the last section
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                // Append to the last section if sender matches
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
            } else {
                // Add a new section for the new message
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
    }
}

// MARK: - MSGDataSource
extension AIAssistantViewController: MSGDataSource {
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
}
