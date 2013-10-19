# ID and content
#
if tip.selector.blank?
  json.type 'broadcast'
else
  json.type 'tip'
  json.selector tip.selector
end

json.id      tip.id
json.content tip.content
