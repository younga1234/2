---
name: catchup
description: 변경사항 분석 및 현재 진행상황 파악
---

# 프로젝트 현황 파악

다음을 순서대로 수행하세요:

## 1. Git 상태 확인

```bash
git status --short
git branch -v
```

## 2. 최근 변경 파일 분석

```bash
git diff --stat HEAD
git diff HEAD
```

## 3. 최근 커밋 이력

```bash
git log -5 --oneline --graph
```

## 4. 요약 정리

위 정보를 바탕으로 다음을 마크다운 형식으로 정리하세요:

### 📋 변경 파일 목록
- 수정된 파일과 변경 라인 수

### 📝 주요 변경 내용
- 각 파일의 변경 이유 요약

### 🎯 진행 상황
- 완료된 작업
- 진행 중인 작업
- 발견된 문제점

### ⏭️ 다음 작업 제안
- 우선순위가 높은 작업부터 나열
