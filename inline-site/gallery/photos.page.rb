images = files_like '*.{png}'

images.each do |image_path|
  base = File.basename(image_path, File.extname(image_path))

  page = Page.new
  page.tags << '_image'
  page.url = base
  page.title = "My image | #{base}"

  page.attributes.src = image_path

  render page, with: '_permalink.html.erb'
end


gallary = Page.new
gallary.tags << 'image-gallary'
gallary.title = "My gallary"
gallary.url = 'index'
gallary.attributes.images = images

render gallary, with: '_gallery.html.erb'
