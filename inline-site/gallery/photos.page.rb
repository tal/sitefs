images = files_like '*.{png}'

images.each do |image_path|
  base = File.basename(image_path, File.extname(image_path))

  page = new_page
  page.tags << '_image'
  page.href = base
  page.title = "My image | #{base}"

  page.attributes.src = path_for_href(image_path)

  render page, with: '_permalink.html.erb'
end


gallary = new_page
gallary.tags << 'image-gallary'
gallary.title = "My gallary"
gallary.href = 'index'
gallary.attributes.images = images

render gallary, with: '_gallery.html.erb'
