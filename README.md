# rails-next-gemini-app

- Backend: Ruby on Rails (APIモード)
- Frontend: Next.js (TypeScript, App Directory)
- Development: Docker Compose
- Production: Google Cloud Run
- AI: Google Gemini API連携

## 使い方

### 1. .envを作成
cp .env.sample .env

### 2. ビルド＆起動
docker-compose up --build

- Rails API: http://localhost:3001
- Next.js:   http://localhost:3000

### 3. Google Cloud Runデプロイ
各サービスのDockerfileでビルド後、Cloud Run等でdeployしてください。

## Gemini API連携

POST /api/gemini に prompt を送るとAI返答を返します。
