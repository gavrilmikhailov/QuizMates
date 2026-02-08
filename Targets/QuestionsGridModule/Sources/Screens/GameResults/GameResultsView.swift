//
//  GameResultsView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import DeviceKit
import SwiftUI

@MainActor
protocol GameResultsViewDelegate: AnyObject {
    func didTapOk()
}

struct GameResultsView: View {
    @Bindable var viewModel: GameResultsViewModel
    weak var delegate: GameResultsViewDelegate?

    var body: some View {
        GeometryReader { geoProxy in
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Grid(alignment: .leading) {
                        ForEach(viewModel.results) { result in
                            GridRow(alignment: .center) {
                                Text("\(result.place)")
                                Text(result.playerNames)
                                Text("\(result.score)")
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button(
                        action: {
                            delegate?.didTapOk()
                        },
                        label: {
                            Text("Готово")
                                .font(.title3)
                                .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(bottom: Device.current.isPad ? 32: 0)
                    Spacer()
                }
            }
        }
    }
}
