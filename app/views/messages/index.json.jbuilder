# vim: ft=ruby
#
json.array! @messages do |message|
  key = message.class.model_name.param_key.intern
  json.partial! key.to_s, key => message
end
