//
//  ConfigurationView.swift
//
//  Created by JechtSh0t on 8/24/22.
//  Copyright © 2022 Brook Street Games. All rights reserved.
//

import SwiftUI

///
/// A screen for adjusted game configuration.
///
struct ConfigurationView: View {
    
    // MARK: - Properties -
    
    let viewModel: ConfigurationViewModel
    
    // MARK: - UI -
    
    var body: some View {
        VStack {
            configurationRows
            defaultsButton
        }
        .foregroundStyle(Color.text)
        .padding(.bottom, 24)
        .screenBackground()
        .customPopover(
            isPresented: Binding(
                get: { viewModel.inputProperty != nil },
                set: { _ in viewModel.inputPropertyDismissed() }
            ),
            content: { dismissAction in
                PlayersView(
                    players: viewModel.configuration.players,
                    dismissAction: dismissAction,
                    actionHandler: viewModel.playerActionSelected
                )
            }
        )
    }
}

// MARK: - Rows -

extension ConfigurationView {
    
    private var configurationRows: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.configurationProperties.indices, id: \.self) { index in
                    let property = viewModel.configurationProperties[index]
                    if let property = property as? ConfigurationViewModel.IncrementConfigurationProperty {
                        IncrementRow(viewModel: viewModel, property: property)
                    } else if let property = property as? ConfigurationViewModel.InputConfigurationProperty {
                        InputRow(viewModel: viewModel, property: property)
                    } else if let property = property as? ConfigurationViewModel.ToggleConfigurationProperty {
                        ToggleRow(viewModel: viewModel, property: property)
                    }
                }
            }
            .padding(24)
        }
    }
    
    private struct IncrementRow: View {

        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.IncrementConfigurationProperty
        
        var body: some View {
            HStack {
                explanationView(title: property.title, description: property.description)
                Spacer()
                IncrementerView(
                    value: Binding(
                        get: { property.currentValue },
                        set: { viewModel.incrementPropertyChanged(property, to: $0) }
                    ),
                    increment: property.increment,
                    minimum: property.minimum,
                    maximum: property.maximum,
                    font: (name: "Lexend", size: 28),
                    display: property.display
                )
            }
            .multilineTextAlignment(.leading)
        }
    }
    
    private struct InputRow: View {

        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.InputConfigurationProperty
        
        var body: some View {
            Button(action: {
                viewModel.inputPropertySelected(property)
            }, label: {
                HStack {
                    explanationView(title: property.title, description: property.description)
                    Spacer()
                    Text(property.display)
                        .font(.custom("Lexend", size: 28))
                }
                .multilineTextAlignment(.leading)
            })
        }
    }
    
    private struct ToggleRow: View {
        
        let viewModel: ConfigurationViewModel
        let property: ConfigurationViewModel.ToggleConfigurationProperty
        
        var body: some View {
            Button(action: {
                viewModel.togglePropertyChanged(property)
            }, label: {
                HStack {
                    explanationView(title: property.title, description: property.description)
                    Spacer()
                    Text(property.currentOption.display)
                        .font(.custom("Lexend", size: 28))
                }
                .multilineTextAlignment(.leading)
            })
        }
    }
    
    private static func explanationView(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Lexend", size: 18))
                .bold()
            Text(description)
                .font(.custom("Lexend", size: 14))
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
    }
}

// MARK: - Defaults Button -

extension ConfigurationView {
    
    private var defaultsButton: some View {
        Button(action: {
            viewModel.defaultsButtonSelected()
        }, label: {
            Text("Restore Defaults")
                .font(.custom("Lexend", size: 28))
        })
    }
}

// MARK: - Previews -

#Preview {
    let viewModel = ConfigurationViewModel(configurationService: ConfigurationServiceMock())
    ConfigurationView(viewModel: viewModel)
}
