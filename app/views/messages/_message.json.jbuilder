# Renders a single tip / tutorial as JSON
# The type of partial to use is inferred
# from the model name.

key = message.class.model_name.param_key.intern
json.partial! key.to_s, key => message
json.url dismiss_message_url(key, message.id)
