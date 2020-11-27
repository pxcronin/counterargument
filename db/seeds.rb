require "faker"

# Argument.all.each do |a|
#   a.argument_id = nil
#   a.save
# end
Vote.destroy_all
ArgumentParentChildRelationship.destroy_all
TagsArgument.destroy_all
Tag.destroy_all
# Reindexing algolia
Argument.clear_index!
Argument.destroy_all
Argument.reindex!
User.destroy_all


emails = %w[nawel@email.com patrick@email.com nooshin@email.com tatiana@email.com JasonBigHands@email.com spud@email.com jadam@email.com brick@email.com trumane@email.com jst@email.com]

puts "Generating users..."
emails.each do |email|
  user = User.new(email: email, password: 123456 )
  user.nickname = user.email.match(/.+?(?=@)/).to_s
  user.save!
end

puts "Generating tags..."
tag_names = ["Politics", "Global Warming", "Religion", "Vaccination", "BLM", "COVID-19", "Environment"]
tag_names.each do |tag_name|
  Tag.create!(name: tag_name)
end

puts "Generating arguments..."
parent = Argument.create!(
  content: "Global warming is not real",
  source: Faker::Internet.url,
  # votes: (0..1000).to_a.sample,
  user: User.all.sample
)
parent2 = Argument.create!(
  content: "Global overpopulation is a myth",
  source: Faker::Internet.url,
  # votes: (0..1000).to_a.sample,
  user: User.all.sample
)
child = Argument.create!(
  content: "Global temperature is rising",
  source: Faker::Internet.url,
  # votes: (0..1000).to_a.sample,
  user: User.all.sample,
)
child2 = Argument.create!(
  content: "A lot of countries have famines",
  source: Faker::Internet.url,
  # votes: (0..1000).to_a.sample,
  user: User.all.sample,
)

ArgumentParentChildRelationship.create!(child: child, parent: parent)
ArgumentParentChildRelationship.create!(child: child2, parent: parent2)
TagsArgument.create!(argument: parent, tag: Tag.find_by(name: "Politics"))
TagsArgument.create!(argument: parent, tag: Tag.find_by(name: "Environment"))
TagsArgument.create!(argument: parent, tag: Tag.find_by(name: "Global Warming"))
TagsArgument.create!(argument: parent2, tag: Tag.find_by(name: "Politics"))
TagsArgument.create!(argument: child2, tag: Tag.find_by(name: "Politics"))
TagsArgument.create!(argument: child, tag: Tag.find_by(name: "Global Warming"))
TagsArgument.create!(argument: child, tag: Tag.find_by(name: "Environment"))
TagsArgument.create!(argument: child, tag: Tag.find_by(name: "Politics"))

10.times do
  argument = Argument.new(
    content: Faker::Quote.yoda,
    source: Faker::Internet.url,
    # votes: (0..1000).to_a.sample,
    user: User.all.sample
  )

  argument.save
  TagsArgument.create!(argument: argument, tag: Tag.all.sample)
end
