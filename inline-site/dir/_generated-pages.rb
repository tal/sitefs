each_image do |image, page|
  page.template = '_image_template.html.erb'
  page.name = image.name + '.html'
  page.tags = ['image', 'generated-pages']
  page.attributes['published'] = '2016-05-12 12:33pm'
  page.locals.image = image
end
