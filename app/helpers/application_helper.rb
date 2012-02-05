module ApplicationHelper

	#Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	#Returns the logo image link
	def logo
		image = "http://railstutorial.org/images/sample_app/logo.png"
		alt = "Sample App"
		css_class = 'round'
		image_tag(image, alt: alt, class: css_class)
	end
end
