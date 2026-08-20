import SwiftUI
import Photos

struct SwipeView: View {
    let deletionManager: DeletionManager

    private let swipeThreshold: CGFloat = 100
    private let transitionDuration: Double = 0.18

    @StateObject
    private var model: SwipeViewModel

    @State private var offset: CGSize = .zero

    init(deletionManager: DeletionManager) {
        self.deletionManager = deletionManager
        _model = StateObject(
            wrappedValue: SwipeViewModel(
                deletionManager: deletionManager
            )
        )
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)

            if let next = model.next {
                MediaView(asset: next, isCurrent: false)
                    .id(next.localIdentifier)
                    .opacity(offset == .zero ? 0 : 1)
            }

            if let current = model.current {
                MediaView(asset: current, isCurrent: true)
                    .id(current.localIdentifier)
                    .background {
                        Color(uiColor: .systemBackground)
                            .opacity(offset == .zero ? 1 : 0)
                    }
                    .offset(offset)
            } else {
                ContentUnavailableView(
                    "No Media",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text(
                        "Your photo library doesn't contain any media."
                    )
                )
            }
        }
        .contentShape(Rectangle())
        .gesture(dragGesture)
        .ignoresSafeArea()
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { value in
                let x = value.translation.width
                let y = value.translation.height

                if y < -swipeThreshold {
                    delete()
                } else if x < -swipeThreshold {
                    next()
                } else {
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

    private func delete() {
        withAnimation {
            offset.height = -500
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + transitionDuration
        ) {
            model.markCurrentForDeletion()
            offset = .zero
        }
    }
}

#Preview {
    SwipeView(deletionManager: DeletionManager())
}
