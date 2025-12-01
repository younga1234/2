---
name: PR준비
description: Pull Request 제출 전 준비 체크리스트
---

# PR 준비 체크리스트

## 1. 코드 품질 검사

### 린팅
```bash
python -m flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
python -m flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
```

### 포매팅 (설치된 경우)
```bash
python -m black . --check || true
```

## 2. 테스트 실행

```bash
python -m pytest tests/ -v --cov=src --cov-report=term-missing
```

## 3. 변경사항 최종 확인

```bash
git diff master --stat
git diff master
git log master..HEAD --oneline
```

## 4. PR 정보 수집

다음 정보를 수집하세요:
- 변경 파일 개수
- 추가/삭제된 코드 라인 수
- 추가된 테스트 개수
- 테스트 커버리지 변화
- Breaking changes 여부

## 5. PR 타이틀 및 설명 작성

### 타이틀 형식
```
<타입>: <간단한 설명>

예시:
feat: JWT 인증 시스템 추가
fix: 사용자 권한 검사 버그 수정
docs: API 문서 업데이트
refactor: 인증 모듈 리팩토링
test: 사용자 API 테스트 추가
```

### 설명 템플릿
```markdown
## 📝 요약
- 변경 사항 요약 (3-5줄)

## 🎯 배경 및 목적
- 왜 이 변경이 필요한가?
- 어떤 문제를 해결하는가?

## 🔧 주요 변경사항
- 변경 내용을 항목별로 나열
- 각 변경의 이유 설명

## ✅ 테스트
- 어떻게 테스트했는가?
- 테스트 커버리지: XX%
- 수동 테스트 시나리오

## 📸 스크린샷 (UI 변경시)
- Before/After 스크린샷
- 데모 영상 링크

## ⚠️ Breaking Changes
- 하위 호환성 문제가 있다면 명시
- 마이그레이션 가이드 제공

## 📋 체크리스트
- [ ] 테스트 추가/업데이트
- [ ] 문서 업데이트
- [ ] CHANGELOG 업데이트
- [ ] 코드 리뷰 준비 완료
```

## 6. 최종 확인

- [ ] 모든 테스트 통과
- [ ] Lint 오류 없음
- [ ] 커밋 메시지 명확함
- [ ] `.env` 파일 커밋 안 됨
- [ ] 민감 정보 노출 없음
- [ ] 문서 업데이트 완료
- [ ] Breaking changes 문서화

위 체크리스트를 확인하고 PR 정보를 제공하세요.
