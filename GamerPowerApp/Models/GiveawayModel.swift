//
//  GiveawayModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//

import Foundation


enum Platform: String, CaseIterable, Hashable {
    case all
    case pc
    case steam
    case ios
    case android
}

struct GiveawayResponse: Codable {
    let giveaways: [GiveawayModel]
}

struct GiveawayModel: Codable, Identifiable {
    let id: Int
    let title: String
    let worth: String?
    let thumbnail: String?
    let image: String?
    let description: String?
    let instructions: String?
    let openGiveawayURL: String?
    let publishedDate: String?
    let type: String?
    let platforms: String?
    let endDate: String?
    let users: Int?
    let status: String?
    let gamerpowerURL: String?
    let openGiveaway: String?
    var platformArray: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, worth, thumbnail, image, description, instructions, type, platforms, users, status
        case openGiveawayURL = "open_giveaway_url"
        case publishedDate = "published_date"
        case endDate = "end_date"
        case gamerpowerURL = "gamerpower_url"
        case openGiveaway = "open_giveaway"
    }
    
    init(id: Int, title: String, worth: String? = nil, thumbnail: String? = nil, image: String? = nil, description: String? = nil, instructions: String? = nil, openGiveawayURL: String? = nil, publishedDate: String? = nil, type: String? = nil, platforms: String? = nil, endDate: String? = nil, users: Int? = nil, status: String? = nil, gamerpowerURL: String? = nil, openGiveaway: String? = nil) {
        self.id = id
        self.title = title
        self.worth = worth
        self.thumbnail = thumbnail
        self.image = image
        self.description = description
        self.instructions = instructions
        self.openGiveawayURL = openGiveawayURL
        self.publishedDate = publishedDate
        self.type = type
        self.platforms = platforms
        self.endDate = endDate
        self.users = users
        self.status = status
        self.gamerpowerURL = gamerpowerURL
        self.openGiveaway = openGiveaway
    }
}
