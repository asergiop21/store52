# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

# Usuario por defecto
user = User.create!(
  name: 'Administrator',
  username: 'admin',
  email: 'admin@project.com',
#  language: 'es',
  password: 'adminproject',
  password_confirmation: 'adminproject',
  role: 'admin'
  # admin: true,
 # enable: true
)

