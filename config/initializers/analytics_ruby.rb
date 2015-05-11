AnalyticsRuby = Segment::Analytics.new(
  write_key: Settings.segmentio_write_key,
  on_error: Proc.new { |_status, msg| print msg }
)
