require 'feedjira'
require 'httparty'
require 'jekyll'

module Jekyll
  class MediumPostDisplay < Generator
    safe true
    priority :high

    def generate(site)
      jekyll_coll = Jekyll::Collection.new(site, 'external_feed')
      site.collections['external_feed'] = jekyll_coll

      xml = HTTParty.get("https://medium.com/feed/@tyburg").body
      feed = Feedjira.parse(xml)
      p "Got #{feed.entries.count} entries"
      feed.entries.each do |e|
        p "Title: #{e.title}, published on Medium #{e.url}"
        title = e[:title]
        content = e[:content]
        guid = e[:url]
        path = "./external_feed/" + title + ".md"
        path = site.in_source_dir(path)
        
        p "doc makin"
        doc = Jekyll::Document.new(path, {:site => site, :collection => jekyll_coll})
        doc.data['title'] = title;
        doc.data['feed_content'] = content;
        
        jekyll_coll.docs << doc
      end
    end
  end
end
