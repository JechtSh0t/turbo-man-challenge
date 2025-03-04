//
//  Configuration.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import BSGAppBasics
import Foundation

///
/// Configuration for a game.
///
struct Configuration: Codable {
    var blueprints: [EventBlueprint]
    var eventsPerRound: Int
    var maxRoundTime: Int
    var minRoundTime: Int
    var players: [String]
    var showCountdown: Bool
    var voice: Voice
}

extension Configuration {
    
    static var `default` = Configuration(
        blueprints: EventBlueprint.default,
        eventsPerRound: 3,
        maxRoundTime: 5.minutes,
        minRoundTime: 1.minutes,
        players: ["Phil", "Matt", "Tom", "Tyler", "James"],
        showCountdown: false,
        voice: Voice.allCases[0]
    )
}
