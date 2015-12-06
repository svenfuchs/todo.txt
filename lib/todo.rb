module Todo
  MSGS = {
    unknown_cmd:    'Unknown command %p',
    item_not_found: 'Could not find item for: %s',
    multiple_items: 'Multiple items found for: %s'
  }

  STATUSES = {
    done: 'x',
    pend: '-'
  }

  Error = Class.new(StandardError)
end
