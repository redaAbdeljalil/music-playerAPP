import Foundation

extension TimeInterval {
    /// Formats a duration as "m:ss", e.g. 195 -> "3:15". Falls back to
    /// "0:00" for non-finite or negative values so the UI never shows
    /// garbage while a track is still loading.
    var mmss: String {
        guard self.isFinite, self >= 0 else { return "0:00" }
        let totalSeconds = Int(self.rounded())
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
