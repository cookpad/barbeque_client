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
response = Barbeque.enqueue(
  job:     'NotifyAuthor',       # @param [String] job     - Job name to enqueue.
  message: { user_id: 7553989 }, # @param [Object] message - An object which is serializable as JSON.
  queue:   'default',            # @param optional [String] queue - A queue name to enqueue a job.
  environment: 'production',     # @param optional [String] environment - Optional meta data.
)
response.message_id #=> "7f62a27d-6181-4b66-95be-ac6066c77cf3"
```

### Polling the job's status

```rb
message_id = '7f62a27d-6181-4b66-95be-ac6066c77cf3'
Barbeque.status(message_id) #=> :success
```
