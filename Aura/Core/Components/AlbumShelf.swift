import SwiftUI

/// Horizontal album rail. Requires a `.navigationDestination(for: Album.self)` somewhere up the
/// enclosing NavigationStack — every tab root registers one, so this works from any tab.
struct AlbumShelf: View {
    let albums: [Album]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AURASpacing.md) {
                ForEach(albums) { album in
                    NavigationLink(value: album) {
                        tile(for: album)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AURASpacing.md)
        }
    }

    private func tile(for album: Album) -> some View {
        VStack(alignment: .leading, spacing: AURASpacing.xxs) {
            ArtworkView(assetName: album.artworkAssetName, seed: album.id)
                .frame(width: 140, height: 140)
            Text(album.title)
                .font(AURAType.caption)
                .foregroundStyle(AURAColor.bone)
                .lineLimit(1)
            Text(album.artistName)
                .font(AURAType.label)
                .foregroundStyle(AURAColor.ash)
                .lineLimit(1)
        }
        .frame(width: 140, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(album.title), \(album.artistName)")
        .accessibilityAddTraits(.isButton)
    }
}
