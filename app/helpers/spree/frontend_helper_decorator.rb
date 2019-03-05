Spree::FrontendHelper.module_eval do

  def taxon_popup_children(root_taxon, always)
    return '' if root_taxon.leaf?
    taxons = root_taxon.children.map do |taxon|     
      desc = taxon.description.nil? || taxon.description.empty? ? '' : "<span class=\"taxonomies-subtaxon-description\">#{taxon.description}</span>"
        #badge = "<span class='badge badge-light'>#{Spree::Product.in_taxon(taxon).count}</span>"
        #link = link_to("<span class=\"taxonomies-subtaxon-name\">#{taxon.name}</span> #{badge}#{desc}".html_safe, seo_url(taxon), class: 'taxonomies-subtaxon-link')
  
        link = link_to("<span class=\"taxonomies-subtaxon-name\">#{taxon.name}</span>#{desc}".html_safe, seo_url(taxon), class: 'taxonomies-subtaxon-link')
      "<div class=\"taxonomies-subtaxon\">#{link}</div>"
    end
    return '' if taxons.empty? && !always
    img = image_tag(root_taxon.background.url(:large), class: 'taxonomies-taxon-background')
    "<div class=\"popover\">
    #{img}
    <h3 class=\"popover-title\"><a href=\"#{seo_url(root_taxon)}\">#{root_taxon.name}</a></h3><div class=\"taxonomies-subtaxon-list\">#{taxons.join("\n")}</div>
    </div>".html_safe
  end

  def taxons_tree2(root_taxon, current_taxon, max_level = 1, offset = '')

    return '' if root_taxon.leaf?

    tax = current_taxon || root_taxon

    taxons = tax.children.map do |taxon|
      css_class = (current_taxon == taxon) ? 'list-group-item active' : 'list-group-item'
      popup_children = taxon_popup_children(taxon, false)
      show_chevron = false
      popup_children = '' if !current_taxon.nil? && current_taxon != root_taxon
      if show_chevron || !popup_children.empty?
        chevron = '<span class="taxon-chevron glyphicon glyphicon-chevron-right pull-right"></span>'
      else
        chevron = ''
      end
       if ENV['http_BADGES'].nil?
        badge = "<span class='badge badge-light'>#{Spree::Product.in_taxon(taxon).available.count}</span>"
        link = link_to("#{offset}#{taxon.name} #{badge}#{chevron}".html_safe, seo_url(taxon), class: 'taxonomies-taxon-link')
       else
         link = link_to("#{offset}#{taxon.name} #{chevron}".html_safe, seo_url(taxon), class: 'taxonomies-taxon-link')
       end
       "<li class=\"#{css_class} taxonomies-taxon\">#{link}#{popup_children}</li>"

    end

    html = taxons.join("\n").html_safe

    return '' if html.empty?

    if offset == ''
      content_tag :ul, html, class: 'list-group', id: 'taxonomies_taxons_tree'
    else
      html
    end

  end

end
