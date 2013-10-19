# A tutorial
json.type   'tutorial'
json.id     tutorial.id
json.title  tutorial.title
json.tips(tutorial.tips) do |json, tip|
  json.partial! 'tip', :tip => tip
end
