//
//  AIAssistantViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/27.
//

import Foundation
import UIKit
import MessengerKit
import ChatGPTSwift

class AIAssistantViewController: MSGMessengerViewController {
    // Users in the chat
    let steve = User(displayName: "Steve", avatar: nil, avatarUrl: nil, isSender: true)
    
    let chatgpt = User(displayName: "ChatGPT", avatar: nil, avatarUrl: nil, isSender: false)
    
    // MARK: - Use xiaoai transfer site to access chatgpt service(https://a.xiaoai.plus/)
    //let api = ChatGPTAPI(apiKey: APIKeys.chatGPTAPIKey)
    let api = ChatGPTAPI(apiKey: APIKeys.xiaoaiAPIKey)
    
    // Messages
    lazy var messages: [[MSGMessage]] = {
        return [
            [
                MSGMessage(id: 1, body: .text("Hi, I am your personal car consultant. May I ask if you need any help? 😉"), user: chatgpt, sentAt: Date()),
            ]
        ]
    }()
    
    private var initialBrand: String?
    private var hasSentInitialBrand = false
    
    private var initailPriceResult: PriceResult?
    private var hasSentInitialPriceResult = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(brand: String) {
        self.init()
        self.initialBrand = brand
    }
    
    convenience init(priceResult: PriceResult) {
        self.init()
        self.initailPriceResult = priceResult
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let brand = initialBrand, !hasSentInitialBrand {
            hasSentInitialBrand = true
            sendAndRetriveMessage(messageText: "Can you tell me something about \(brand)?")
        }
        
        if let priceResult = initailPriceResult, !hasSentInitialPriceResult {
            hasSentInitialPriceResult = true
            sendAndRetriveMessageWithOptimization(messageTextWantToShow: "What do you think of this \(priceResult.make ?? "") \(priceResult.model ?? "") \(priceResult.bodyType ?? "")? Is it worth buying?", messageTextWantToSendToAI: "What do you think of this car: \(priceResult)? Is it worth buying?")
        }
    }
    
    // Override the inputViewPrimaryActionTriggered to simulate Tim sending a message with keyboard input
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        // Get the message text entered by the user (Tim in this case)
        let messageText = inputView.message
        sendAndRetriveMessage(messageText: messageText)
    }
    
    private func sendAndRetriveMessage(messageText: String) {
        guard !messageText.isEmpty else { return }

        let steveMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(messageText), user: steve, sentAt: Date())

        // Insert the new message into the conversation
        insert(steveMessage)
        
        Task {
            do {
                let response = try await api.sendMessage(text: messageText)
                let timMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(response), user: chatgpt, sentAt: Date())
                insert(timMessage)
                
                print(response)
            } catch {
                let errorMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(error.localizedDescription), user: chatgpt, sentAt: Date())
                insert(errorMessage)
                
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendAndRetriveMessageWithOptimization(messageTextWantToShow: String, messageTextWantToSendToAI: String) {
        guard !messageTextWantToShow.isEmpty, !messageTextWantToSendToAI.isEmpty else { return }

        let steveMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(messageTextWantToShow), user: steve, sentAt: Date())

        // Insert the new message into the conversation
        insert(steveMessage)
        
        Task {
            do {
                let response = try await api.sendMessage(text: messageTextWantToSendToAI)
                let timMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(response), user: chatgpt, sentAt: Date())
                insert(timMessage)
                
                print(response)
            } catch {
                let errorMessage = MSGMessage(id: messages.flatMap { $0 }.count + 1, body: .text(error.localizedDescription), user: chatgpt, sentAt: Date())
                insert(errorMessage)
                
                print(error.localizedDescription)
            }
        }
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
