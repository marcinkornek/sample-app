# atom_feed :language => 'en-US' do |feeds|
#   feeds.title @title
#   feeds.updated @updated

#   @feeds_items.each do |item|
#     next if item.updated_at.blank?

#     feeds.entry( item ) do |entry|
#       entry.url feed_url(item)
#       # entry.title item.title
#       entry.content item.content, :type => 'html'

#       # the strftime is needed to work with Google Reader.
#       entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

#       entry.author do |author|
#         author.name entry.author_name
#       end
#     end
#   end
# end

