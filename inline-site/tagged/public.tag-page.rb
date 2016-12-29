public_tags.each do |tag|
  page = Page.new
  page.title = "Tagged #{tag}"
  page.url = tag
  page.attributes.tag = tag

  render page, with: '_tag_layout.html.erb'
end
