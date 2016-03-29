# barbeque-ruby

Barbeque client for Ruby.

## Installation

Add this line to your application's Gemfile:

```rb
gem 'barbeque'
```

And create "config/initializers/barbeque.rb" and edit it like:

```rb
Barbeque.configure do |config|
  config.application   = 'cookpad'
  config.default_queue = 'default'
  config.endpoint      = 'https://barbeque.example.com'
end
```

## Usage
### Enqueuing a job

```rb
execution = Barbeque.enqueue(
  job:     'NotifyAuthor',       # @param [String] job     - Job name to enqueue.
  message: { user_id: 7553989 }, # @param [Object] message - An object which is serializable as JSON.
  queue:   'default',            # @param optional [String] queue - A queue name to enqueue a job.
  environment: 'production',     # @param optional [String] environment - Optional meta data.
)
execution.message_id #=> "a3c653c1-335e-4d4d-a6f9-eb91c0253d02"
execution.status     #=> "pending"
```

### Polling the job's status

```rb
message_id = "a3c653c1-335e-4d4d-a6f9-eb91c0253d02"
Barbeque.status(message_id: message_id) #=> "success"
```
