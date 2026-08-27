import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var playback: PlaybackManager
    @EnvironmentObject private var libraryStore: UserLibraryStore

    let namespace: Namespace.ID
    @Binding var isExpanded: Bool

    @State private var isQueuePresented = false
    @State private var dragOffset: CGFloat = 0
    @State private var breathe = false

    private let library: MusicLibraryProviding = CatalogMusicLibraryService()

    var body: some View {
        if let track = playback.currentTrack {
            ZStack {
                ambientBackground(for: track)

                VStack(spacing: 0) {
                    header
                    Spacer(minLength: AURASpacing.lg)
                    artwork(for: track)
                    Spacer(minLength: AURASpacing.xl)
                    trackInfo(track: track)
                    scrubber
                    controls
                    Spacer(minLength: AURASpacing.xl)
                }
                .padding(.horizontal, AURASpacing.lg)
                .padding(.top, AURASpacing.sm)
                .padding(.bottom, AURASpacing.xl)
            }
            .background(AURAColor.ink)
            .offset(y: max(0, dragOffset))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 120 {
                            collapse()
                        } else {
                            withAnimation(AURAMotion.spring) { dragOffset = 0 }
                        }
                    }
            )
            .onAppear { breathe = true }
            .sheet(isPresented: $isQueuePresented) {
                QueueSheetView()
                    .environmentObject(playback)
            }
            .accessibilityAddTraits(.isModal)
        }
    }

    private func collapse() {
        withAnimation(AURAMotion.spring) {
            dragOffset = 0
            isExpanded = false
        }
    }

    // MARK: - Pieces

    private var header: some View {
        HStack {
            Button(action: collapse) {
                Image(systemName: AURAIcon.chevronDown)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AURAColor.bone)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(AURAColor.inkElevated))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Minimize")

            Spacer()

            Text("PLAYING FROM \(playback.queue.count) TRACKS")
                .font(AURAType.label)
                .foregroundStyle(AURAColor.ash)

            Spacer()

            Button {
                isQueuePresented = true
            } label: {
                Image(systemName: AURAIcon.queue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AURAColor.bone)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(AURAColor.inkElevated))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Queue")
        }
    }

    private func ambientBackground(for track: Track) -> some View {
        ArtworkView(
            assetName: track.artworkAssetName,
            seed: track.albumID,
            tintHex: library.artist(byID: track.artistID)?.accentColorHex,
            cornerRadius: 0
        )
        .scaleEffect(1.6)
        .blur(radius: 70)
        .opacity(0.55)
        .rotationEffect(.degrees(breathe ? 6 : -6))
        .animation(.easeInOut(duration: 14).repeatForever(autoreverses: true), value: breathe)
        .ignoresSafeArea()
        .overlay(AURAColor.ink.opacity(0.35).ignoresSafeArea())
    }

    private func artwork(for track: Track) -> some View {
        ArtworkView(
            assetName: track.artworkAssetName,
            seed: track.albumID,
            tintHex: library.artist(byID: track.artistID)?.accentColorHex,
            cornerRadius: AURARadius.lg
        )
        .matchedGeometryEffect(id: "playerArtwork", in: namespace)
        .frame(width: 300, height: 300)
        .scaleEffect(breathe && playback.isPlaying ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: breathe)
        .auraShadow(AURAShadow.elevated)
    }

    private func trackInfo(track: Track) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(AURAType.display)
                    .foregroundStyle(AURAColor.bone)
                    .lineLimit(1)
                Text(track.artistName)
                    .font(AURAType.body)
                    .foregroundStyle(AURAColor.ash)
                    .lineLimit(1)
            }
            Spacer()
            LikeButton(isLiked: libraryStore.isLiked(track)) {
                libraryStore.toggleLike(track)
            }
            .padding(.top, AURASpacing.xxs)
        }
        .padding(.top, AURASpacing.md)
        .accessibilityElement(children: .combine)
    }

    private var scrubber: some View {
        VStack(spacing: AURASpacing.xxs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(AURAColor.inkElevated).frame(height: 4)
                    Capsule().fill(AURAColor.bone).frame(width: geometry.size.width * progressFraction, height: 4)
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard geometry.size.width > 0 else { return }
                            let fraction = min(max(0, value.location.x / geometry.size.width), 1)
                            playback.seek(to: fraction * playback.duration)
                        }
                )
            }
            .frame(height: 20)

            HStack {
                Text(playback.progress.mmss)
                Spacer()
                Text((playback.duration - playback.progress).mmss)
            }
            .font(AURAType.label)
            .foregroundStyle(AURAColor.ash)
        }
        .padding(.top, AURASpacing.lg)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Playback progress")
        .accessibilityValue("\(playback.progress.mmss) of \(playback.duration.mmss)")
    }

    private var progressFraction: CGFloat {
        guard playback.duration > 0 else { return 0 }
        return CGFloat(playback.progress / playback.duration)
    }

    private var controls: some View {
        HStack(spacing: AURASpacing.xl) {
            Button {
                playback.toggleShuffle()
                HapticsManager.selection()
            } label: {
                Image(systemName: AURAIcon.shuffle)
                    .foregroundStyle(playback.shuffleEnabled ? AURAColor.ember : AURAColor.ash)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Shuffle")
            .accessibilityAddTraits(playback.shuffleEnabled ? .isSelected : [])

            Button {
                playback.skipPrevious()
                HapticsManager.tap()
            } label: {
                Image(systemName: AURAIcon.previous)
                    .font(.system(size: 22))
                    .foregroundStyle(AURAColor.bone)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Previous")

            Button {
                playback.togglePlayPause()
                HapticsManager.tap()
            } label: {
                Image(systemName: playback.isPlaying ? AURAIcon.pause : AURAIcon.play)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(AURAColor.ink)
            }
            .buttonStyle(.auraCircular(size: 72))
            .accessibilityLabel(playback.isPlaying ? "Pause" : "Play")

            Button {
                playback.skipNext()
                HapticsManager.tap()
            } label: {
                Image(systemName: AURAIcon.next)
                    .font(.system(size: 22))
                    .foregroundStyle(AURAColor.bone)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next")

            Button {
                playback.cycleRepeatMode()
                HapticsManager.selection()
            } label: {
                Image(systemName: playback.repeatMode == .one ? AURAIcon.repeatOne : AURAIcon.repeatAll)
                    .foregroundStyle(playback.repeatMode == .off ? AURAColor.ash : AURAColor.ember)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Repeat")
            .accessibilityAddTraits(playback.repeatMode == .off ? [] : .isSelected)
        }
        .font(.system(size: 18))
        .padding(.top, AURASpacing.xl)
        .frame(maxWidth: .infinity)
    }
}
