Sentry.init do |config|
  config.dsn = 'https://83121686b24f3b847db6af2e8a71e797@o4509270849748992.ingest.de.sentry.io/4509270866657360'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end