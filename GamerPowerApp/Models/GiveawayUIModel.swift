//
//  GiveawayUIModel.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 17/02/2025.
//


import Foundation

struct GiveawayUIModel: Identifiable {
    var id: Int
    var title: String
    var image: String?
    var users: Int?
    var type: String?
    var thumbnail: String?
    var description: String?
    var platforms: String?
    var formattedEndDate: String?
    var openGiveawayURL: String?
    var platformArray: [String]?
    
    init(from model: GiveawayModel) {
        self.id = model.id
        self.title = model.title
        self.image = model.image
        self.type = model.type
        self.thumbnail = model.thumbnail
        self.description = model.description
        self.platforms = model.platforms
        self.openGiveawayURL = model.openGiveawayURL
        self.users = model.users
        self.formattedEndDate = model.endDate?.toFormattedDate()
        self.platformArray = model.platforms?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
