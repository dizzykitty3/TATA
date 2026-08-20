//
//  SwipeView.swift
//  TATA
//
//  Created by Theo on 8/19/26.
//

import SwiftUI
import Photos

struct SwipeView: View {

    private let swipeThreshold: CGFloat = 100
    private let transitionDuration: Double = 0.18

    @StateObject
    private var model =
        SwipeViewModel()

    @State private var offset:
        CGSize = .zero

    var body: some View {
        ZStack {
            Color(
                uiColor:
                    .systemBackground
            )

            if let previous = model.previous {
                MediaView(
                    asset: previous,
                    isCurrent: false
                )
                .id(previous.localIdentifier)
                .opacity(
                    offset.width > 0 ? 1 : 0
                )
            }

            if let next = model.next {
                MediaView(
                    asset: next,
                    isCurrent: false
                )
                .id(next.localIdentifier)
                .opacity(
                    offset.width < 0 ? 1 : 0
                )
            }

            if let current = model.current {
                MediaView(
                    asset: current,
                    isCurrent: true
                )
                .id(current.localIdentifier)
                .background {
                    Color(
                        uiColor:
                            .systemBackground
                    )
                    .opacity(
                        offset == .zero
                        ? 1
                        : 0
                    )
                }
                .offset(
                    offset
                )
            }
        }
        .contentShape(Rectangle())
        .gesture(dragGesture)
        .ignoresSafeArea()
    }
}

extension SwipeView {
    private var dragGesture:
        some Gesture {

        DragGesture()
            .onChanged { value in
                offset =
                    value.translation
            }
            .onEnded { value in
                let x =
                    value.translation.width

                let y =
                    value.translation.height

                if y < -swipeThreshold {
                    delete()

                }
                else if x < -swipeThreshold {
                    next()

                }
                else if x > swipeThreshold {
                    previous()

                }
                else {
                    withAnimation {
                        offset = .zero
                    }
                }
            }
    }

    private func next() {
        guard model.next != nil else {
            withAnimation {
                offset = .zero
            }
            return
        }

        withAnimation(.easeOut(duration: transitionDuration)) {
            offset.width = -500
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + transitionDuration
        ) {

            model.moveNext()

            offset = .zero
        }
    }

    private func previous() {
        guard model.previous != nil else {
            withAnimation {
                offset = .zero
            }
            return
        }

        withAnimation(.easeOut(duration: transitionDuration)) {
            offset.width = 500
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + transitionDuration
        ) {
            model.movePrevious()
            offset = .zero
        }
    }

    private func delete() {
        withAnimation {
            offset.height = -500
        }

        model.deleteCurrent {
            offset = .zero
        }
    }
}

#Preview {
    SwipeView()
}
