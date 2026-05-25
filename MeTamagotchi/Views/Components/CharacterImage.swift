import SwiftUI

/// stage 0~4 캐릭터를 시각화한다.
/// 자산은 Assets.xcassets/character_stage{0..4}.imageset.
/// isWilted 시 채도를 0으로 떨어뜨리고 밝기를 살짝 낮춰 "시들함"을 표현.
struct CharacterImage: View {
    let stage: Int
    let isWilted: Bool

    private var assetName: String {
        let clamped = min(max(stage, 0), 4)
        return "character_stage\(clamped)"
    }

    var body: some View {
        let base = Image(assetName)
            .resizable()
            .scaledToFit()

        Group {
            if isWilted {
                base
                    .saturation(0)
                    .brightness(-0.1)
            } else {
                base
            }
        }
        .accessibilityLabel("캐릭터 \(stage)단계\(isWilted ? ", 시들함" : "")")
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { stage in
                CharacterImage(stage: stage, isWilted: false)
                    .frame(width: 60, height: 60)
            }
        }
        HStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { stage in
                CharacterImage(stage: stage, isWilted: true)
                    .frame(width: 60, height: 60)
            }
        }
    }
    .padding()
}
