
# 🔗 URL Shortener API

> A clean, production-ready **URL Shortener API** built with **Ruby on Rails (API mode)**.
> Designed with scalability, clarity, and real-world backend practices in mind.

🌍 **Live Demo**
👉 [https://mental-raychel-ovian-066274f9.koyeb.app/](https://mental-raychel-ovian-066274f9.koyeb.app/)

---

## 🚀 Features

* ✅ Generate short URLs
* ✅ Decode short URLs
* ✅ Public redirect endpoint
* ✅ Click tracking
* ✅ Rate limiting via **Rack::Attack**
* ✅ Structured JSON error handling
* ✅ API-first architecture
* ✅ Deployed to **Koyeb**

---

## 🏗 Architecture Overview

The application follows a **clean separation of concerns**:

```
Controllers → Services → Models → Database
```

### Services

* **`UrlEncoder`** – Generates short codes and persists records
* **`UrlDecoder`** – Extracts code from short URL and resolves the original URL
* **`CodeGenerator`** – Generates high-entropy Base62 codes

### Controllers

* **`Api::UrlsController`** – JSON API endpoints (encode / decode)
* **`RedirectsController`** – Public redirect handler

> ✅ The API layer is fully separated from redirect logic.

---

## 🔑 Slug vs Code

This application does **not** use human-readable slugs.

Instead, it uses a **Base62 opaque identifier** called `code`.

Example:

```
https://mental-raychel-ovian-066274f9.koyeb.app/aZ93Kq
```

* `aZ93Kq` → unique public identifier
* Randomly generated
* High entropy
* Non-guessable
* Safer for public exposure

---

## 🔌 API Endpoints

### 🔹 Encode URL

`POST /encode`

```bash
curl -X POST https://mental-raychel-ovian-066274f9.koyeb.app/encode   -H "Content-Type: application/json"   -d '{"url":"https://google.com"}'
```

**Response**

```json
{
  "data": {
    "short_url": {
      "code": "aZ93Kq",
      "url": "https://mental-raychel-ovian-066274f9.koyeb.app/aZ93Kq"
    }
  }
}
```

---

### 🔹 Decode URL

`POST /decode`

```bash
curl -X POST https://mental-raychel-ovian-066274f9.koyeb.app/decode \
  -H "Content-Type: application/json" \
  -d '{"short_url":"https://mental-raychel-ovian-066274f9.koyeb.app/aZ93Kq"}'
```

**Response**

```json
{
  "data": {
    "url": "https://example.com"
  }
}
```

---

## ⚠️ Error Format

All errors follow a **consistent JSON structure**:

```json
{
  "error": {
    "code": "invalid_request",
    "message": "Missing required parameter: url"
  }
}
```

### Environment Behavior

| Environment | Behavior                         |
| ----------- | -------------------------------- |
| Development | Full stack trace                 |
| Test        | Fail loudly                      |
| Production  | Generic 500 + structured logging |

---

## 🔐 Security

### Implemented

* ✅ Rate limiting (Rack::Attack)
* ✅ Unique index on `code`
* ✅ Strong random Base62 generation
* ✅ Production-safe error responses

### Intentionally Not Implemented (for simplicity)

* ❌ SSRF protection
* ❌ Blocking private/internal IP ranges
* ❌ Blocking `javascript:` / `data:` schemes
* ❌ Reserved slugs
* ❌ Vanity/custom URLs

> These are clearly scoped for future iterations.

---

## 📊 Database Schema

### `short_urls`

| Column       | Type            |
| ------------ | --------------- |
| id           | integer         |
| original_url | string          |
| code         | string (unique) |
| clicks_count | integer         |
| created_at   | datetime        |
| updated_at   | datetime        |

---

## 🧪 Test Coverage

Run tests with:

```bash
bundle exec rspec
```

Coverage includes:

* ✔ Services (encode / decode)
* ✔ API endpoints
* ✔ Redirect behavior
* ✔ Error handling

**Why this matters**

* Business logic tested independently
* Controllers tested via request specs
* Side effects verified
* Safe refactoring

---

## 🏭 Deployment

**Stack**

* Koyeb
* PostgreSQL
* Puma

**Required Environment Variables**

```env
RAILS_ENV=production
SECRET_KEY_BASE=...
DATABASE_URL=...
```

---

## 🧠 Design Philosophy

This project prioritizes:

* API-first design
* Clear ownership boundaries
* Minimal but extensible feature set
* Production-ready defaults
* Readability over cleverness

---

## 📈 Scalability Improvements (Planned)

### 🔴 Current Bottleneck

* Every redirect hits PostgreSQL
* Every click updates DB row
* High traffic → DB contention

---

### 🟢 Redis Integration

#### A) Cache Original URLs

```ruby
Redis.current.get("short:#{code}")
```

* Reduces DB reads
* Sub-millisecond redirects
* Massive throughput gain

#### B) Move Click Counting to Redis

```ruby
Redis.current.incr("clicks:#{code}")
```

* Periodic flush to DB
* Avoids write amplification
* Prevents row-level locking

---

### 🟣 Kafka (Event-Driven Architecture)

Publish click events instead of synchronous DB writes:

```json
{
  "code": "aZ93Kq",
  "ip": "192.168.1.10",
  "timestamp": "2026-02-10T12:00:00Z",
  "user_agent": "Chrome"
}
```

Enables:

* Analytics pipelines
* Fraud detection
* Event replay
* Horizontal scaling

---

## 🧭 Architecture at Scale

```
┌─────────────┐
│   API App   │
└──────┬──────┘
       │
┌──────▼──────┐
│    Redis    │
└──────┬──────┘
       │
┌──────▼──────┐
│ PostgreSQL  │
└──────┬──────┘
       │
┌──────▼──────┐
│   Kafka     │
└──────┬──────┘
       │
┌──────▼─────────────┐
│ Analytics / BI / ML│
└────────────────────┘
```

---

## 👤 Author

Built as a **production-ready Rails API** demonstrating:

* Service-oriented architecture
* Clean error handling
* Rate limiting
* Redirect pipelines
* Deployment readiness

---

## 🚀 Next Enhancements

* SSRF protection
* URL expiration
* Custom vanity URLs
* Redis-backed caching
* Admin analytics dashboard
* Horizontal scaling strategy

