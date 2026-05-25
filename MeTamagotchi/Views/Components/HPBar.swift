import SwiftUI

struct HPBar: View {
    let hp: Int

    private var ratio: CGFloat {
        CGFloat(max(0, min(100, hp))) / 100
    }

    private var color: Color {
        switch hp {
        case 51...: .green
        case 21...50: .yellow
        default: .red
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.secondary.opacity(0.2))
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(width: geo.size.width * ratio)
                    .animation(.easeInOut(duration: 0.3), value: hp)
            }
        }
        .frame(height: 12)
        .accessibilityElement()
        .accessibilityLabel("HP")
        .accessibilityValue("\(hp)")
    }
}

#Preview {
    VStack(spacing: 16) {
        HPBar(hp: 100)
        HPBar(hp: 60)
        HPBar(hp: 35)
        HPBar(hp: 10)
        HPBar(hp: 0)
    }
    .padding()
}
