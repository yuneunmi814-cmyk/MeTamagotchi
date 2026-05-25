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
