# frozen_string_literal: true

require 'rspotify'
require 'selenium-webdriver'
require 'google/apis/youtube_v3'
require File.dirname(__FILE__) + '/constants'

module Spotify
  # @Resolver private
  class Resolver
    # @return [String]
    attr_reader :base_url

    # @return [String]
    attr_reader :youtube_api

    # @return [Object]
    attr_reader :youtube_search

    # @return [String]
    attr_reader :spotify_client_id

    # @return [String]
    attr_reader :spotify_client_secret

    # @param youtube_api [String]
    # @param spotify_client_id [String]
    # @param spotify_client_secret [String]
    def initialize(youtube_api, spotify_client_id, spotify_client_secret)
      @base_url = "https://www.youtube.com/watch?v="
      @youtube_api = youtube_api
      @youtube_search = Google::Apis::YoutubeV3::YouTubeService.new
      @spotify_client_id = spotify_client_id
      @spotify_client_secret = spotify_client_secret
    end

    # A simple way to handle authorization.
    def authorization(payload)
      RSpotify.authenticate(@spotify_client_id, @spotify_client_secret)
      @youtube_search.key = @youtube_api
    end

    # @param youtube_api [String]
    # @param spotify_client_id [String]
    # @param spotify_client_secret [String]
    def self.[](youtube_api, spotify_client_id, spotify_client_secret)
      new(youtube_api, spotify_client_id, spotify_client_secret)
    end

    # @param milliseconds [Integer]
    def resolve_duration(milliseconds)
      (Time.at(milliseconds / 1000.0)).utc.strftime("%M:%S")
    end  

    # @param media [String]
    def apple_music(media)
      driver = Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
      driver.get media

      name = driver.page_source.match(REGEX[7])[0]
      artist = driver.page_source.match(REGEX[8])[1]
      driver.quit

      authorization(true) if @youtube_search && @spotify_client_id
      song = RSpotify::Track.search("#{name} #{artist}")
      return false if song.empty?

      response = @youtube_search.list_searches('id,snippet', q: "#{song[0].name} #{song[0].artists.first.name}", max_results: 1)
      ["#{@base_url}#{response.items.first.id.video_id}", song[0].name, song[0].artists.first.name, resolve_duration(song[0].duration_ms), song[0].album.images[0]['url']]
    end

    # @param media [String]
    def raw_resolve(media)
      authorization(true) if @youtube_search && @spotify_client_id
      song = RSpotify::Track.search(media)
      return false if song.empty?

      response = @youtube_search.list_searches('id,snippet', q: "#{song[0].name} #{song[0].artists.first.name}", max_results: 1)
      ["#{@base_url}#{response.items.first.id.video_id}", song[0].name, song[0].artists.first.name, resolve_duration(song[0].duration_ms), song[0].album.images[0]['url']]
    end  

    # @param media [String]
    def resolve(media)
      authorization(true) if @youtube_search && @spotify_client_id
      song = RSpotify::Track.find(media[1])
      response = @youtube_search.list_searches('id,snippet', q: "#{song.name} #{song.artists.first.name}", max_results: 1)
      ["#{@base_url}#{response.items.first.id.video_id}", song[0].name, song[0].artists.first.name, resolve_duration(song[0].duration_ms), song[0].album.images[0]['url']]
    end
  end
end
