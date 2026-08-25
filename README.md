# Devise::Sessionable

Devise extension for per-device session tracking and soft invalidation.

## Installation

```ruby
gem "devise-sessionable"
```

Local path (development):

```ruby
gem "devise-sessionable", path: "/path/to/devise-sessionable"
```

```bash
bundle install
rails generate devise_sessionable:install
rails db:migrate
```

## Setup

### 1. User model

Add `:sessionable` to your Devise modules:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :sessionable
  # ...
end
```

### 2. Controllers

Include the trackable concern where Devise helpers are available:

```ruby
class ApplicationController < ActionController::Base
  include Devise::Sessionable::Controllers::SessionTrackable
end
```

If you use an API base controller that also calls `sign_in`, include it there too.
API token auth with `sign_in(user, store: false)` is skipped automatically.

### 3. Invalidate sessions (e.g. from a webhook)

```ruby
user.invalidate_all_sessions!
```

Active sessions are soft-invalidated (`invalidated_at` set). The next request for
those devices signs the user out.

### 4. Purge old invalidated rows (optional)

Schedule in your job runner, e.g. SolidQueue `config/recurring.yml`:

```yaml
purge_expired_user_sessions:
  command: "Devise::Sessionable::PurgeExpiredJob.perform_now(before: 1.month.ago)"
  schedule: every day at 4:00 am
```

Retention is configured by the host via the `before:` argument.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
