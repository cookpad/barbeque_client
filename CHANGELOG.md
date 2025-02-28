## v0.11.0 (2025-01-16)
- Update BarbequeAdapter for Rails 7.2 compatibility
- Drop support for Ruby 2.6, 2.7, and 3.0

## v0.10.2 (2019-11-21)
- Use 'running' instead of 'working' in mock API responses

## v0.10.1 (2018-11-09)
- Add support for custom HTTP headers

## v0.10.0 (2018-08-24)
- Add documentation for ActiveJob adapter
- Drop support for Ruby 2.1
- Support delay_seconds parameter
  - Also supports ActiveJob's enqueue_at method
  - Requires Barbeque >= v2.5.0

## v0.9.1 (2017-06-19)
- Fix NoMethodError in distributed tracing

## v0.9.0 (2017-05-30)
- Support distributed tracing
  - See https://github.com/cookpad/barbeque_client#distributed-tracing for details.

## v0.8.2 (2017-03-17)
- Add `fields` option to Client#execution

## v0.8.1 (2017-03-14)
- Add naive status management in barbeque:runner

## v0.8.0 (2016-09-01)
- Initial release
