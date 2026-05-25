# 나를 키우는 다마고찌 — MVP 명세서

> Claude Code 진입용 단일 명세서. 이 문서 + `CLAUDE.md`만 있으면 1.0 출시까지 충분.

---

## 1. 프로젝트 개요

**한 줄 컨셉**: 매일 습관을 체크하면 내 다마고찌(몬스터)가 자라고, 안 하면 시들해진다.

**플랫폼**: iOS 17+ (SwiftUI + SwiftData)
**개발 기간 목표**: 4주 (TestFlight 3주차, 심사 4주차)
**백엔드**: 없음 (전부 로컬, on-device)
**수익화**: v1은 무료. IAP는 v1.1 이후.

**핵심 원칙**:
- 기능 추가하지 말 것. 빠지는 게 미덕.
- 못생겨도 출시. 폴리싱은 v1.1.
- 분기·소셜·서버 전부 v2.

---

## 2. 핵심 루프 (이게 전부)

```
사용자가 앱을 연다
  → 오늘의 습관 3개 표시
  → 체크하면 캐릭터 HP +15, 누적 카운트 +1
  → 자정에 미체크 항목당 HP -20
  → 누적 카운트가 임계값 도달 → 진화
  → HP 0 → 시들함 상태 (죽지 않음)
```

이 루프를 망가뜨리는 모든 제안은 거절한다.

---

## 3. 데이터 모델 (SwiftData)

### `Character`
```
id: UUID
name: String              // 사용자가 짓는 이름
createdAt: Date
hp: Int                   // 0~100, 시작 100
totalChecks: Int          // 누적 체크 횟수 (진화 트리거)
stage: Int                // 0~4 (알/베이비/차일드/틴/어덜트)
isWilted: Bool            // HP=0 도달 여부
lastDecayAt: Date         // 마지막 자정 감쇠 처리 시각
```

### `Habit`
```
id: UUID
title: String             // "운동 30분", "성경 읽기" 등
emoji: String             // "💪", "📖" 등 (1자)
order: Int                // 0, 1, 2 (3개 고정)
createdAt: Date
```

### `CheckIn`
```
id: UUID
habitId: UUID
date: Date                // 자정 기준 그날 날짜
checkedAt: Date           // 실제 체크 시각
```

**제약**: 같은 (habitId, date) 조합은 1일 1회만. 중복 체크 불가.

### `EvolutionLog` (도감용)
```
id: UUID
characterId: UUID
fromStage: Int
toStage: Int
evolvedAt: Date
```

---

## 4. 진화 규칙

| Stage | 이름 | 누적 체크 임계값 | 비고 |
|-------|------|----------------|------|
| 0 | 알 | 0 | 시작 상태 |
| 1 | 베이비 | 6 | 약 2일치 (3개×2일) |
| 2 | 차일드 | 21 | 약 1주치 |
| 3 | 틴 | 42 | 약 2주치 |
| 4 | 어덜트 | 90 | 약 1달치 |

- 진화는 단방향. 퇴화 없음.
- HP는 진화와 무관 (게이지일 뿐, 진화 트리거는 totalChecks).
- 시들함(HP=0)이어도 진화 조건 충족하면 진화함. 단 UI는 시들한 모습으로 표시.
- HP 회복: 체크할 때마다 +15, 최대 100.

---

## 5. 자정 감쇠 로직

**언제 실행**: 앱 진입 시 `lastDecayAt` 확인 → 자정을 넘겼으면 그동안의 일수만큼 처리.

**처리 방식**:
```
지난 자정 이후의 각 날짜 D에 대해:
  미체크 habit 개수 = 3 - CheckIn(date=D).count
  HP -= (미체크 개수 × 20)
HP = max(0, HP)
lastDecayAt = 지금
```

- 백그라운드 작업 안 씀. 앱 진입 시 lazy 처리.
- 사용자가 며칠 만에 들어와도 한 번에 계산.

---

## 6. 화면 (4개)

### 6.1 메인 화면 `MainView`
- 상단: 캐릭터 이름 + HP 게이지 바
- 중앙: 캐릭터 이미지 (stage별 5종, isWilted면 회색톤)
- 하단: 오늘의 습관 3개 카드
  - 각 카드: 이모지 + 제목 + 체크 버튼
  - 체크되면 비활성 + 체크 표시
- 우상단 톱니바퀴 → 설정

### 6.2 온보딩 / 습관 설정 `HabitSetupView`
- 첫 진입 시 1회 강제
- 캐릭터 이름 입력
- 습관 3개 입력 (제목 + 이모지)
- "시작하기" → 메인으로

### 6.3 도감 `CollectionView`
- 현재 캐릭터의 진화 히스토리 (EvolutionLog 기반)
- 각 단계 이미지 + 진화 날짜
- 미달성 단계는 실루엣 처리

### 6.4 설정 `SettingsView`
- 캐릭터 이름 변경
- 습관 3개 수정
- 알림 시간 설정 (v1.1에서 실제 푸시 연결, v1은 UI만)
- 리셋 (새 캐릭터 시작)
- 앱 버전, 개인정보처리방침 링크

---

## 7. 디자인 가이드 (MVP 한정)

- **색상**: 시스템 컬러 + 강조색 1개 (예: `Color.indigo`)
- **폰트**: SF Pro (시스템)
- **캐릭터 이미지**: 64×64 PNG 5장 + 시들 버전 5장 (총 10장). 도트 픽셀 스타일.
  - 첫 빌드는 임시 SF Symbols로 자리만 잡고 (`egg`, `pawprint.fill` 등), 출시 전 교체.
- **다크모드**: 자동 대응 (시스템 색상만 쓰면 됨)

---

## 8. 파일 구조

```
MeTamagotchi/
├── MeTamagotchiApp.swift          // @main, ModelContainer 설정
├── Models/
│   ├── Character.swift
│   ├── Habit.swift
│   ├── CheckIn.swift
│   └── EvolutionLog.swift
├── Views/
│   ├── MainView.swift
│   ├── HabitSetupView.swift
│   ├── CollectionView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── HPBar.swift
│       ├── CharacterImage.swift
│       └── HabitCard.swift
├── Logic/
│   ├── DecayService.swift         // 자정 감쇠
│   ├── EvolutionService.swift     // 진화 트리거 체크
│   └── CheckInService.swift       // 체크인 처리 (중복 방지 포함)
├── Assets.xcassets/
│   └── Characters/                // egg, baby, child, teen, adult (+ wilted 버전)
└── Resources/
    └── Localizable.strings        // ko + en
```

---

## 9. 작업 순서 (Claude Code 작업 청크)

각 청크는 독립적으로 끝내고 빌드 통과 확인할 것.

**Chunk 1 — 프로젝트 셋업** (0.5일)
- Xcode 프로젝트 생성 (iOS App, SwiftUI, SwiftData)
- 파일 구조 만들기
- ModelContainer에 4개 모델 등록
- 빈 4개 View 생성 + NavigationStack 골격

**Chunk 2 — 데이터 레이어** (1일)
- 4개 모델 구현
- `CheckInService.checkIn(habit:)`: 중복 방지 + HP +15 + totalChecks +1
- `DecayService.applyDecayIfNeeded()`: 자정 감쇠 계산
- `EvolutionService.checkEvolution()`: 임계값 체크 + 로그 생성
- 단위 테스트 (XCTest) 최소 3개: 체크인 중복 / 감쇠 다일 / 진화 트리거

**Chunk 3 — 온보딩** (0.5일)
- HabitSetupView 구현
- 첫 진입 판단 (Character가 없으면 온보딩)
- 캐릭터 + 습관 3개 생성 후 메인 진입

**Chunk 4 — 메인 화면** (1일)
- HPBar 컴포넌트
- CharacterImage 컴포넌트 (stage + isWilted 대응)
- HabitCard 컴포넌트 + 체크 동작
- 앱 진입 시 DecayService 호출
- 체크 시 EvolutionService 호출 → 진화 애니메이션 (단순 페이드)

**Chunk 5 — 도감 & 설정** (0.5일)
- CollectionView
- SettingsView
- 리셋 동작 (Character + 관련 데이터 삭제 후 온보딩으로)

**Chunk 6 — 폴리싱 & 빌드** (1주)
- 캐릭터 이미지 교체 (10장)
- 앱 아이콘 (1024×1024)
- 스플래시 (LaunchScreen)
- 한국어 + 영어 로컬라이징
- TestFlight 빌드 업로드
- 스토어 메타데이터 (스크린샷 6장, 설명문, 키워드)

**Chunk 7 — 심사 대응** (1주, 버퍼)

---

## 10. v1에서 절대 안 하는 것

- 푸시 알림 실제 발송 (UI만)
- 백엔드/계정/로그인
- 분기 진화 / 다중 캐릭터 동시 보유
- 소셜·공유·랭킹
- 통계 차트
- 인앱결제
- 위젯 / 라이브 액티비티
- 애플워치 연동
- 캐릭터 커스터마이징
- 미니게임

전부 v1.1 이후 백로그.

---

## 11. 출시 체크리스트

- [ ] 앱 아이콘 1024×1024
- [ ] 스크린샷 6.7"(iPhone 15 Pro Max) × 3장 이상
- [ ] 한국어 앱 설명문 (≤ 4,000자)
- [ ] 영어 앱 설명문
- [ ] 키워드 (한/영 각 100자)
- [ ] 개인정보처리방침 URL (정적 페이지, Cloudflare Pages로 호스팅)
- [ ] 지원 URL
- [ ] 만 4세 이상 등급
- [ ] TestFlight 외부 테스터 1명 이상 통과
- [ ] 크래시 0건 (Xcode Organizer 확인)

---

## 12. 폴더에 같이 둘 `CLAUDE.md` (Claude Code용 컨텍스트)

별도 파일로 만들어서 프로젝트 루트에 둘 것. 내용:

```
이 프로젝트는 "나를 키우는 다마고찌" iOS MVP다.
SPEC.md를 항상 먼저 읽고 작업한다.

규칙:
- 기능 추가 금지. SPEC.md "v1에서 절대 안 하는 것" 목록을 어기지 않는다.
- SwiftUI + SwiftData만 쓴다. UIKit 직접 사용 금지.
- 외부 라이브러리 추가 금지 (SPM 의존성 0개 유지).
- 모든 텍스트는 Localizable.strings 거친다. 하드코딩 금지.
- 비동기 작업은 async/await만. Combine 금지.
- 테스트는 핵심 로직(체크인·감쇠·진화)에만 작성.
- 커밋 메시지는 한국어 conventional commits (feat:, fix:, chore: …).
```

---

작업 시작 시 Claude Code에 첫 프롬프트로 던질 문장:

> "SPEC.md와 CLAUDE.md를 읽고, Chunk 1부터 시작해줘. Xcode 프로젝트는 내가 이미 만들어뒀어 (경로: ./MeTamagotchi). 각 Chunk 끝나면 빌드 통과 확인하고 멈춰."
