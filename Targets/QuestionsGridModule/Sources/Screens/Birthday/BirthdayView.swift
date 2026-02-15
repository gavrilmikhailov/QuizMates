//
//  BirthdayView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 15.02.2026.
//

import SwiftUI
import Vortex

struct BirthdayView: View {
    @Bindable var viewModel: BirthdayViewModel

    var body: some View {
        GeometryReader { geoProxy in
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("С днем рождения, чыычаах)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .opacity(viewModel.opacity)
                        .mask(Rectangle().offset(x: viewModel.offset))
                    Spacer()
                }
                Spacer()
            }
            .overlay {
                VortexViewReader { vortexProxy in
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
                    .onChange(of: viewModel.confettiToggle) { _, _ in
                        guard geoProxy.size != .zero else {
                            return
                        }
                        Task { [width = geoProxy.size.width, height = geoProxy.size.height] in
                            let numberOfBursts = 20
                            let interval: TimeInterval = 0.5

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
            .overlay {
                if viewModel.fireworksOn {
                    VortexView(.fireworks) {
                        Circle()
                            .fill(.white)
                            .blendMode(.plusLighter)
                            .frame(width: 32)
                            .tag("circle")
                    }
                }
            }
        }
    }
}
