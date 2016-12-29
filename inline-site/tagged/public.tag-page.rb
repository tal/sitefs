public_tags.each do |tag|
  page = new_page
  page.title = "Tagged #{tag}"
  page.href = tag
  page.attributes.tag = tag

  render page, with: '_tag_layout.html.erb'
end
