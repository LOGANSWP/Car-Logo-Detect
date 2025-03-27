//
//  User.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/27.
//

import Foundation
import MessengerKit

class User: MSGUser {
    var displayName: String
    var avatar: UIImage?
    var avatarUrl: URL?
    var isSender: Bool
    
    init(displayName: String, avatar: UIImage? = nil, avatarUrl: URL? = nil, isSender: Bool) {
        self.displayName = displayName
        self.avatar = avatar
        self.avatarUrl = avatarUrl
        self.isSender = isSender
    }
}
