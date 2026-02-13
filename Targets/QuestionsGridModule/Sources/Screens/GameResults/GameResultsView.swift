//
//  GameResultsView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import DeviceKit
import SwiftUI
import Vortex

@MainActor
protocol GameResultsViewDelegate: AnyObject {
    func didTapOk()
}

struct GameResultsView: View {
    @Bindable var viewModel: GameResultsViewModel
    weak var delegate: GameResultsViewDelegate?

    var body: some View {
        GeometryReader { geoProxy in
            VortexViewReader { vortexProxy in
                ZStack {
                    VortexView(.confetti) {
                        Circle()
                            .fill(.white)
                            .blendMode(.plusLighter)
                            .frame(width: 16, height: 16)
                            .tag("circle")
                        Rectangle()
                            .fill(.white)
                            .blendMode(.plusLighter)
                            .frame(width: 16, height: 16)
                            .tag("square")
                    }
                    .ignoresSafeArea(edges: .all)

                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
                                ForEach(viewModel.results) { result in
                                    GridRow(alignment: .center) {
                                        Text(result.placeEmoji)
                                            .font(.title)
                                        Text(result.playerNames)
                                            .font(.title)
                                        Text(result.score)
                                            .font(.title)
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
                                    Text(Strings.gameResultsAction)
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
                    .onChange(of: viewModel.confettiToggle) { _, _ in
                        guard geoProxy.size != .zero else {
                            return
                        }
                        Task { [width = geoProxy.size.width, height = geoProxy.size.height] in
                            let numberOfBursts = 20
                            let interval: TimeInterval = 0.1

                            for _ in 0..<numberOfBursts {
                                let randomX = CGFloat.random(in: 20...(width - 20))
                                let randomY = CGFloat.random(in: 20...(height - 20))

                                await MainActor.run {
                                    vortexProxy.move(to: CGPoint(x: randomX, y: randomY))
                                    vortexProxy.burst()
                                }

                                try? await Task.sleep(for: .seconds(interval))
                            }
                        }
                    }
                }
            }
        }
    }
}
