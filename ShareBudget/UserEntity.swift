//
//  UserEntity.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 09/09/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

struct UserEntity: Codable {
    let userID: Int?
    let email: String?
    let isRemoved: Bool?
    let lastName: String?
    let firstName: String?
    let timeStamp: String?
}
