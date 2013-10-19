# vim: ft=ruby
#
json.array! @messages do |message|
  key = message.class.model_name.param_key.intern
  json.partial! "scripts/#{key}", key => message
end
