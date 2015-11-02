class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy, :crawl]
  before_action :connect_transmission, only: [:index, :add_torrent]

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
  end

  # GET /crawl/1
  # GET /crawl/1.json
  def crawl
    collected_links = mejortorrent_crawl
    process_links(collected_links)
    redirect_to(@show)
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(show_params)

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.json { render :show, status: :created, location: @show }
      else
        format.html { render :new }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url, notice: 'Show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(:name, :description, :active)
    end

    # Creates the season if it doesn't exists yet
    def season_control(show, season_number)
        @season = Season.where(number: season_number, show_id: @show.id).first
        unless @season
            @season = Season.new(number: season_number, show_id: @show.id)
            @season.save
        end

        return @season
    end

    # Creates the chapter if it doesn't exists yet
    def chapter_control(show, season_number, chapter_number)
        @season = Season.where(number: season_number, show_id: @show.id).first
        unless Chapter.exists?(number: chapter_number, season_id: @season.id)
            @chapter = Chapter.new(number: chapter_number, season_id: @season.id)
            @chapter.save
        end
    end

    # Adds the torrent to transmission
    def add_torrent(url, show, season, episode)
      path_base = Settings.shows_download_folder

      begin
        torrent = Transmission::Model::Torrent.add arguments: {filename: url}, fields: ['id'], connector: @rpc
        torrent.stop!
        location = path_base + "/" + @show.name + "/" + season + "/"
        torrent.set_location location , true
        Rails.logger.debug("--------> Location: #{location}")
        torrent.save!
      rescue => ex
        logger.error ex.message
      end
    end

    def mejortorrent_crawl
      require 'nokogiri'
      require 'open-uri'
      collected_links = Array.new

      url_base = "http://www.mejortorrent.com"

      doc = Nokogiri::HTML(open(url_base + "/secciones.php?sec=buscador&valor=" + @show.name))
      doc.css('a').each do |link|
          # Rails.logger.debug("Show: #{link.inspect}")
          # Rails.logger.debug("Show text: #{link['text']}")

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

    def process_links(link_collection)
      link_collection.each do |link|
        unless Chapter.where(number: link.chapter, season_id: link.season).first
          chapter_control(@show, link.season, link.chapter)
          add_torrent(link.url, link.show, link.season, link.chapter)
        end
      end
    end

    def connect_transmission
      require 'transmission'
      @rpc = Transmission::Config.set host: Settings.transmission.host, port: Settings.transmission.port, ssl: false, credentials: {username: Settings.transmission.user, password: Settings.transmission.password}
    end
end
