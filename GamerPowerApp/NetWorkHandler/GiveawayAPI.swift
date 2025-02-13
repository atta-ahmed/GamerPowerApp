//
//  GiveawayAPI.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 12/02/2025.
//

import Moya

enum GiveawayAPI {
    case allGiveaways
    case giveawaysByPlatform(platform: String)
}

extension GiveawayAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.gamerpower.com/api")!
    }

    var path: String {
//        return "/giveaways"

        switch self {
        case .allGiveaways:
            return "/giveaways"
        case .giveawaysByPlatform(let platform):
            return "/giveaways?platform=\(platform)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain

//        switch self {
//        case .allGiveaways:
//            return .requestPlain
//        case .giveawaysByPlatform(let platform):
//            return .requestParameters(parameters: ["platform": platform], encoding: URLEncoding.queryString)
//        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

