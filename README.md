# Event Booking API

A simple REST API for managing concert ticket bookings, built with Ruby on Rails.

## Requirements

- Ruby 3.2.2
- Rails 8.1.3
- PostgreSQL

## Getting Started

### 1. Clone and install

```bash
git clone <repository_url>
cd event_booking_api
bundle install
```

### 2. Set up PostgreSQL

```bash
sudo service postgresql start
sudo -u postgres psql
```

```sql
CREATE USER your_username WITH CREATEDB PASSWORD 'your_password';
\q
```

### 3. Configure the database

Edit `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  username: your_username
  password: your_password
  host: localhost
```

### 4. Create, migrate, and seed

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Start the server

```bash
rails server
```

---

## API Endpoints

### Get all events

```
GET /api/v1/events
```

Response:

```json
[
  {
    "id": 1,
    "name": "BNK48",
    "date": "2026-05-10T18:00:00.000Z",
    "capacity": 200,
    "available_tickets": 198
  }
]
```

### Book tickets

```
POST /api/v1/events/:event_id/bookings
```

Request body:

```json
{
  "booking": {
    "email": "john@gmail.com",
    "quantity": 2
  }
}
```

Success response:

```json
{
  "message": "Booking successful",
  "booking": {
    "id": 1,
    "event": "BNK48",
    "email": "john@gmail.com",
    "quantity": 2
  }
}
```

Error response:

```json
{
  "errors": ["Quantity exceeds available tickets"]
}
```

### Validation rules

- Quantity must be greater than 0
- Quantity cannot exceed 10 per booking
- Quantity cannot exceed available tickets

---

## Concurrency Handling

The API uses **pessimistic locking** (`with_lock`) to prevent race conditions. The event row is locked before any validation or save occurs.

```ruby
event.with_lock do
  booking = event.bookings.build(booking_params)
  booking.save
end
```

This covers three scenarios:

- **Two users booking at the same time** — User B waits until User A finishes, then sees the updated ticket count. If tickets are no longer available, User B gets an error.
- **10-ticket limit per booking** — validated inside the lock on every request, so sending multiple concurrent requests cannot bypass the rule.
- **One user buying out all tickets** — available tickets are checked after the lock is acquired every time, so overlapping requests from the same user will still fail if capacity is exceeded.

---

## If I Had More Time

### Core features

- **Booking expiry** — auto-release seats if payment isn't completed within 15 minutes (Sidekiq + Redis)
- **Payment integration** — connect Stripe or Omise; booking status moves from `pending` to `confirmed`
- **Cancellations** — let users cancel and return capacity to the pool
- **Waiting list** — register interest when sold out; auto-notify when a spot opens
- **Request queue** — queue concurrent booking requests via Sidekiq instead of blocking with a lock; reduces timeouts and handles traffic spikes more gracefully