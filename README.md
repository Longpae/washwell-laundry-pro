# 워시웰 런드리프로

PWA/Vercel 배포용 워시웰 런드리프로 모바일 앱입니다.

배포 주소: https://washwell-laundry-pro.vercel.app

## iPhone 설치

1. iPhone Safari에서 배포 주소를 엽니다.
2. 공유 버튼을 누릅니다.
3. `홈 화면에 추가`를 선택합니다.
4. 홈 화면 아이콘으로 실행합니다.

## 배포 설정

- Build Command: `npm run build`
- Output Directory: `dist`
- 환경변수 선택:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`
  - `VITE_WASHWELL_WORKSPACE_ID`

## Supabase

`supabase.sql`을 Supabase SQL Editor에서 실행하면 Realtime 테이블과 RLS 정책을 만들 수 있습니다.
