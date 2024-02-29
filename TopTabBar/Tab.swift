import Foundation
import struct SwiftUI.Color

struct Tab: Identifiable {
    var id: UUID = .init()
    let title: String
    let color: Color
}
