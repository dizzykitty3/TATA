//
//  SwipeView.swift
//  TATA
//
//  Created by Theo on 8/19/26.
//

import SwiftUI
import Photos

struct SwipeView: View {

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

            if let next = model.next {
                MediaView(
                    asset: next
                )
                .id(next.localIdentifier)
                .opacity(
                    offset == .zero ? 0 : 1
                )
            }

            if let current = model.current {
                MediaView(
                    asset: current
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
                .gesture(
                    dragGesture
                )
            }
        }
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

                if y < -150 {
                    delete()

                }
                else if x < -150 {
                    next()

                }
                else {
                    withAnimation {
                        offset = .zero
                    }
                }
            }
    }

    private func next() {
        withAnimation {
            offset.width = -500
        }

        DispatchQueue.main.asyncAfter(
            deadline:
                .now() + 0.25
        ) {

            model.moveNext()

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
