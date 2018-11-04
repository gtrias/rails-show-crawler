require 'nokogiri'
require 'open-uri'

class CrawlService
  def crawl(media)
    return mejortorrent_crawl(media)
  end

  private

  def mejortorrent_crawl(name)
      collected_links = Array.new
      html = get_contents(name)
      doc = Nokogiri::HTML(html.to_s)

      doc.css('a').each do |link|
        if /(\d)-Temporada/.match(link['href'])
            # Rails.logger.debug("Show href: #{link['href']}")
            torrentsdoc = Nokogiri::HTML(open(url_base + link['href']))
            # season = $1
            torrentsdoc.css('a').each do |tlink|
                # Rails.logger.debug("Show href: #{tlink['href']}")
                # Rails.logger.debug("Show season: #{$1}")
                # Show href: /serie-episodio-descargar-torrent-25036-The-Following-3x03.html
                if /([0-9])x([0-9]{2})/.match(tlink['href'])
                    season = $1
                    episode = $2
                    @season = season_control(@show, season)


                    # Check here if we have this chapter or not
                    # Rails.logger.debug("matched show link: #{tlink['href']}")
                    episodepage = Nokogiri::HTML(open(url_base + tlink['href']))
                    episodepage.css('a').each do |stlink|
                      if /secciones\.php\?sec=descargas&ap=contar&tabla=series/.match(stlink['href'])
                        episodetorrentpage = Nokogiri::HTML(open(url_base + '/' + stlink['href']))
                        episodetorrentpage.css('a').each do |stplink|
                          if /\.torrent$/.match(stplink['href'])
                            Rails.logger.debug("matched show: #{stplink['href']}")
                            url = url_base + stplink['href']

                            @link = Link.new(url: url, show: show, season: season, chapter: episode)
                            collected_links << @link
                          end
                        end
                      end
                    end
                end
            end
        end
    end

    return collected_links
  end

  def get_contents(name)
      url_base = "http://www.mejortorrent.com"
      html_code = open(url_base + "/secciones.php?sec=buscador&valor=" + name)
  end

end
