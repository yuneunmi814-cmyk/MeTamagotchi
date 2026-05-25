import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [Character]
    @Query(sort: \Habit.order) private var habits: [Habit]

    @AppStorage("notificationHour") private var notificationHour: Int = 21
    @AppStorage("notificationMinute") private var notificationMinute: Int = 0

    @State private var showResetConfirm = false

    var body: some View {
        Form {
            if let character = characters.first {
                characterSection(character: character)
            }
            habitSection
            notificationSection
            resetSection
            aboutSection
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .alert("리셋하시겠어요?", isPresented: $showResetConfirm) {
            Button("취소", role: .cancel) {}
            Button("리셋", role: .destructive) { reset() }
        } message: {
            Text("캐릭터, 습관, 체크 기록이 모두 삭제되고 새 캐릭터를 만들게 됩니다.")
        }
    }

    @ViewBuilder
    private func characterSection(character: Character) -> some View {
        @Bindable var bindable = character
        Section("캐릭터") {
            TextField("이름", text: $bindable.name)
        }
    }

    @ViewBuilder
    private var habitSection: some View {
        Section("습관 3개") {
            ForEach(habits) { habit in
                habitRow(habit: habit)
            }
        }
    }

    @ViewBuilder
    private func habitRow(habit: Habit) -> some View {
        @Bindable var bindable = habit
        HStack(spacing: 12) {
            TextField("🌱", text: Binding(
                get: { bindable.emoji },
                set: { bindable.emoji = String($0.prefix(1)) }
            ))
            .multilineTextAlignment(.center)
            .frame(width: 44)
            TextField("제목", text: $bindable.title)
        }
    }

    private var notificationSection: some View {
        Section {
            DatePicker(
                "알림 시간",
                selection: notificationTimeBinding,
                displayedComponents: .hourAndMinute
            )
        } header: {
            Text("알림")
        } footer: {
            Text("v1에서는 시간 설정만 저장됩니다. 실제 알림은 다음 업데이트.")
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirm = true
            } label: {
                Text("리셋 (새 캐릭터 시작)")
            }
        }
    }

    private var aboutSection: some View {
        Section("앱 정보") {
            HStack {
                Text("버전")
                Spacer()
                Text(appVersion).foregroundStyle(.secondary)
            }
            // 출시 전 실제 정적 페이지 URL로 교체할 것 (Cloudflare Pages)
            Link("개인정보처리방침", destination: URL(string: "https://example.com/metamagotchi/privacy")!)
        }
    }

    private var appVersion: String {
        let dict = Bundle.main.infoDictionary
        let short = dict?["CFBundleShortVersionString"] as? String ?? "0.0"
        let build = dict?["CFBundleVersion"] as? String ?? "0"
        return "\(short) (\(build))"
    }

    private var notificationTimeBinding: Binding<Date> {
        Binding(
            get: {
                Calendar.current.date(
                    bySettingHour: notificationHour,
                    minute: notificationMinute,
                    second: 0,
                    of: Date()
                ) ?? Date()
            },
            set: { newDate in
                let comps = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                notificationHour = comps.hour ?? 21
                notificationMinute = comps.minute ?? 0
            }
        )
    }

    private func reset() {
        do {
            try modelContext.delete(model: EvolutionLog.self)
            try modelContext.delete(model: CheckIn.self)
            try modelContext.delete(model: Habit.self)
            try modelContext.delete(model: Character.self)
            try modelContext.save()
        } catch {
            print("Reset failed: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(
        for: [Character.self, Habit.self, CheckIn.self, EvolutionLog.self],
        inMemory: true
    )
}
