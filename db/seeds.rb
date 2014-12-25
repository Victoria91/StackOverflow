# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Creating tags...'
tags = Tag.first_or_create([
  { name: 'Ruby' },
  { name: 'Rails' },
  { name: 'JQuery' },
  { name: 'Javascript' },
  { name: 'Python' },
  { name: 'SQL' },
  { name: 'Unix' },
  { name: 'Windows' },
  { name: 'C++' },
  { name: 'VIM' },
  { name: 'Other' }
])