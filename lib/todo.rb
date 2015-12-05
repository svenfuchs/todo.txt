module Todo
  MSGS = {
    unknown_cmd:    'Unknown command %p',
    item_not_found: 'Could not find item for: %s',
    multiple_items: 'Multiple items found for: %s'
  }

  DATES = {
    two_weeks_ago: (Time.now - 60 * 60 * 24 * 14).strftime('%Y-%m-%d'),
    yesterday:     (Time.now - 60 * 60 * 24).strftime('%Y-%m-%d'),
    today:         Time.now.strftime('%Y-%m-%d')
  }

  STATUSES = {
    done: 'x',
    pend: '-'
  }

  Error = Class.new(StandardError)
end
