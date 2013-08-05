# taken wholesale from Shopify's dashing

def send_event(id, body)
  body[:id] = id
  body[:updatedAt] ||= Time.now.to_i
  event = format_event(body.to_json)
  Sinatra::Application.settings.history[id] = event
  Sinatra::Application.settings.connections.each { |out| out << event }
end

def format_event(body)
  "data: #{body}\n\n"
end

def latest_events
  Sinatra::Application.settings.history.inject("") do |str, (id, body)|
    str << body
  end
end
