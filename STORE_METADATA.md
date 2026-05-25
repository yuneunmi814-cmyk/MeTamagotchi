# App Store 메타데이터 초안

> 출시 전 확정·교체 필요한 항목은 `TODO:` 표시. 길이 제약은 App Store Connect 기준.

---

## App Name

- **ko (≤30자)**: 나의 다마고찌
- **en (≤30 chars)**: MeTamagotchi

## Subtitle (부제)

- **ko (≤30자)**: 매일 습관으로 키우는 작은 친구
- **en (≤30 chars)**: Grow a friend with habits

## Promotional Text (≤170자/chars, 심사 없이 교체 가능)

- **ko**: 오늘의 습관 3개. 체크하면 캐릭터가 자라고, 빼먹으면 시들해집니다. 푸시도 광고도 계정도 없는, 가장 단순한 디지털 다마고찌.
- **en**: Three habits a day. Check them off and your monster grows; skip them and it wilts. The simplest digital tamagotchi—no push, no ads, no account.

---

## Description

### 한국어 (≤4,000자)

```
나를 키우는 다마고찌.

매일 정해둔 습관 3개를 체크하면 작은 캐릭터의 HP가 차오르고, 누적 체크 횟수가 일정 단계를 넘으면 진화합니다. 반대로 체크를 놓치면 자정마다 HP가 줄어들고, 0이 되면 캐릭터가 시들해집니다. (죽지는 않습니다. 다시 체크하면 살아납니다.)

[ 특징 ]
• 정말 단순합니다. 화면은 4개뿐: 메인 / 도감 / 설정 / 첫 설정.
• 계정도, 로그인도, 푸시도, 광고도, 인앱결제도 없습니다.
• 모든 데이터는 기기 안에만 저장됩니다. 어디로도 전송되지 않습니다.
• 5단계 진화: 알 → 베이비 → 차일드 → 틴 → 어덜트.
• 며칠 만에 앱을 켜도 그동안의 HP 감소가 한 번에 정리됩니다.

[ 누구를 위한 앱인가요? ]
• 거창한 습관 트래커가 부담스러운 분
• 화려한 차트·통계·뱃지 없이, 그냥 "오늘 했어 / 안 했어"만 묻는 도구가 필요한 분
• 다마고찌·디지몬 키우기를 좋아했던 어른들

[ v1에서 일부러 빼둔 것 ]
복잡함이 단순함을 이기지 않도록, 다음 기능은 의도적으로 넣지 않았습니다.
- 통계 차트
- 소셜·공유·랭킹
- 다중 캐릭터
- 미니게임
- 푸시 알림 (시간 설정 UI만 있고 실제 알림은 다음 업데이트 예정)
- 캐릭터 커스터마이징

지금 가능한 가장 단순한 형태로 먼저 내놓고, 정말 필요한 기능만 더해 가려고 합니다.

[ 만든 사람 ]
혼자 만드는 작은 앱입니다. 의견·버그 제보는 환영합니다.
```

### English (≤4,000 chars)

```
A tamagotchi that grows from your daily habits.

Pick three small habits. Check them off each day and your character's HP fills up and it evolves through five stages. Skip them and HP drains at midnight; at zero, your character wilts. (It doesn't die — check in again and it recovers.)

[ Why it's like this ]
• Just four screens: home, collection, settings, first-time setup.
• No accounts. No sign-in. No push spam. No ads. No in-app purchases.
• All data stays on your device. Nothing is sent anywhere.
• Five stages: Egg → Baby → Child → Teen → Adult.
• Come back after a few days and the missed-day HP loss is settled in one go.

[ Who it's for ]
• People who find big habit trackers exhausting.
• People who don't want charts, badges, or streak shame — just "did it / didn't" today.
• Adults who used to love virtual pets.

[ What's intentionally missing in v1 ]
To keep things simple, these are not in this version:
- Statistics and charts
- Social, sharing, or leaderboards
- Multiple characters
- Mini-games
- Real push notifications (the time picker is there; actual delivery is coming next)
- Character customization

We're starting with the simplest possible thing and only adding what's truly needed.

[ Made by ]
A small solo project. Bug reports and feedback are welcome.
```

---

## Keywords (≤100자/chars, 쉼표 구분)

- **ko**: `다마고찌,습관,루틴,체크리스트,챌린지,캐릭터,키우기,자기관리,모티베이션,데일리`
- **en**: `tamagotchi,habits,routine,streak,checklist,pet,character,daily,self,growth`

---

## What's New (이번 버전 변경사항)

- **ko**: 첫 출시 버전입니다. 즐겁게 키워주세요.
- **en**: First release. Have fun raising it.

---

## Category

- **Primary**: Lifestyle (라이프스타일)
- **Secondary**: Productivity (생산성)

> 게임 카테고리는 Game Center·게임 카테고리 심사 강제 적용 등 부담이 있어 Lifestyle로.

## Age Rating

- 만 4세 이상 (4+)
- 폭력·성인·도박·이용자 생성 콘텐츠 모두 없음

## Primary Language

- 한국어

## URLs

| 항목 | 값 | 상태 |
|---|---|---|
| Privacy Policy URL | TODO: Cloudflare Pages 등에 정적 페이지 호스팅 후 교체 | 필수 |
| Support URL | TODO: Notion 페이지 / 이메일 안내 / GitHub Issues | 필수 |
| Marketing URL (선택) | TODO 또는 비워둠 | 선택 |

코드 안 placeholder: `SettingsView.swift` 의 `https://example.com/metamagotchi/privacy`

## Screenshots (6.7" iPhone 15 Pro Max 기준 ≥3장)

TODO: 시뮬레이터에서 캡처. 추천 구성
1. **온보딩** — 캐릭터 이름 + 습관 3개 입력 화면
2. **메인** — 캐릭터 + HP 바 + 오늘의 습관 카드 (1~2개 체크된 상태)
3. **도감** — 5단계 중 2~3단계 달성 상태
4. (선택) 메인 — 시들함 상태 vs 진화 직후 상태 대비

캡처 방법: `xcrun simctl io booted screenshot ~/Desktop/shot.png` 또는 시뮬레이터 메뉴 → File → New Screenshot.

## Pricing & Availability

- **Price**: Free
- **Availability**: 전 세계 (이슈 없으면)
- **App Store Connect** → Pricing and Availability에서 설정

---

## 제출 전 체크리스트 (SPEC §11 발췌 + 진척)

- [ ] 앱 아이콘 1024×1024 PNG (Assets.xcassets/AppIcon.appiconset)
- [ ] 스크린샷 6.7" ≥3장
- [x] 한국어 앱 설명문 초안
- [x] 영어 앱 설명문 초안
- [x] 키워드 한/영 초안
- [ ] 개인정보처리방침 URL 실제 호스팅
- [ ] 지원 URL
- [x] 만 4세 이상 등급 결정
- [ ] TestFlight 외부 테스터 1명 이상 통과
- [ ] 크래시 0건 (Xcode Organizer)
- [ ] iOS Deployment Target 17.0으로 변경
- [ ] 캐릭터 PNG 10장 교체
