---
name: pr-prep
description: Pull Request 제출 전 준비 체크리스트
---

# PR 준비 체크리스트

## 1. 코드 품질 검사

### Linting
```bash
python -m flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
python -m flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
```

### 포매팅 (있는 경우)
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
```

### 설명 템플릿
```markdown
## 📝 Summary
- 변경 사항 요약 (3-5줄)

## 🎯 Motivation
- 왜 이 변경이 필요한가?

## 🔧 Changes
- 주요 변경 사항 목록

## ✅ Testing
- 어떻게 테스트했는가?
- 테스트 커버리지: XX%

## 📸 Screenshots (UI 변경시)
- 스크린샷 또는 데모

## ⚠️ Breaking Changes
- 하위 호환성 문제가 있다면 명시
```

## 6. 최종 확인

- [ ] 모든 테스트 통과
- [ ] Lint 오류 없음
- [ ] 커밋 메시지 명확함
- [ ] `.env` 파일 커밋 안 됨
- [ ] 민감 정보 노출 없음
- [ ] 문서 업데이트 완료

위 체크리스트를 확인하고 PR 정보를 제공하세요.
