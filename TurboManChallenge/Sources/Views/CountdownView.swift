//
//  CountdownView.swift
//
//  Created by JechtSh0t on 8/23/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI
import BSGAppBasics

///
/// A screen for awaiting the next event.
///
struct CountdownView: View {
    
    // MARK: - Properties -
    
    let game: Game
    @State var soundPlayer = AudioGenerator()
    @State var eventIsActive = false
    
    // MARK: - UI -
    
    var body: some View {
        
        ZStack {
            Color.mainBackground
            VStack {
                if eventIsActive {
                    EventView(events: game.activeEvents, isVisible: $eventIsActive, speaker: Speaker(voiceType: game.configuration.voice))
                            .transition(.scale)
                } else {
                    if game.countdownIsActive {
                        Text("Waiting for Event")
                            .font(.custom("Chalkduster", size: 30.0))
                            .foregroundColor(.text)
                    }
                    if game.configuration.showTimer && game.countdownIsActive {
                        Text(game.roundRemainingTime.timeFormatted ?? "")
                            .font(.custom("Chalkduster", size: 60.0))
                            .foregroundColor(.text)
                    }
                    ActionButton(game: game)
                }
            }
            .padding(.horizontal)
            .onChange(of: game.activeEvents) { _, _ in
                if !game.activeEvents.isEmpty {
                    soundPlayer.playSound("turbo-time")
                    withAnimation { eventIsActive = true }
                }
            }
        }
    }
}

struct ActionButton: View {
    
    let game: Game
    
    var body: some View {
        Button(action: {
            game.countdownIsActive ? game.stopCountdown() : game.startCountdown()
        }, label: {
            Image(systemName: game.countdownIsActive ? "stop.circle.fill" : "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: game.countdownIsActive ? 100 : 150, height: game.countdownIsActive ? 100 : 150)
        })
        .foregroundColor(.text)
    }
}

struct CountdownView_Previews: PreviewProvider {
    
    static var previews: some View {
        CountdownView(game: Game(eventBlueprints: EventBlueprint.all)).preferredColorScheme(.light)
        CountdownView(game: Game(eventBlueprints: EventBlueprint.all)).preferredColorScheme(.dark)
    }
}
