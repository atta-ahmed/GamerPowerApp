//
//  GiveawayModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//

import Foundation

import Foundation

struct GiveawayResponse: Decodable {
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

    enum CodingKeys: String, CodingKey {
        case id, title, worth, thumbnail, image, description, instructions, type, platforms, users, status
        case openGiveawayURL = "open_giveaway_url"
        case publishedDate = "published_date"
        case endDate = "end_date"
        case gamerpowerURL = "gamerpower_url"
        case openGiveaway = "open_giveaway"
    }
}

