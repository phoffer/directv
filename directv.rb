require 'net/http'
require 'json'

module Directv
  module Channels
    ESPN          = 206
    ESPNews       = 207
    ESPNU         = 208
    ESPN2         = 209
    NFL           = 212
    MLB           = 213
    NHL           = 215
    NBA           = 216
    Tennis        = 217
    Golf          = 218
    GSN           = 233
    Spike         = 241
    USA           = 242
    Syfy          = 244
    TNT           = 245
    TruTV         = 246
    Tru           = 246
    TBS           = 247
    FX            = 248
    Comedy        = 249
    CC            = 249
    AMC           = 254
    TV_Land       = 304
    WGN           = 307
    ABC_Fam       = 311
    NBCSN         = 603
    VS            = 603
    CBS_Sports    = 613
    ESPNClassic   = 614
    module FSN
      AZ    = 686
    end
    module HBO
      East        = 501
      East_2      = 502
      Signature   = 503
      West        = 504
      West_2      = 505
      Comedy      = 506
      Family_east = 507
      Family_west = 508
      Zone        = 509
      Latino      = 511
    end

  end
  # available requests
  # TV functionality
    # Get Tuned
      # http://STBIP:port/tv/getTuned
    # Get Program Info
      # http://STBIP:port/tv/getProgInfo?major=num[&minor=num][&time=num] 
    # Tune
      # http://STBIP:port/tv/tune?major=num
  # Remote Keys
    # Remote Keys
      # http://STBIP:port/remote/processKey?key=string
  # Info
    # Get Version
      # http://STBIP:port/info/getVersion
    # Get Options
      # http://STBIP:port/info/getOptions
    # Mode Request
      # http://STBIP:port/info/mode


  class Receiver
    # supported keys:
    # power, poweron, poweroff, format, pause, rew, replay, stop, advance, ffwd, record, play, guide, active, list, exit, back, menu, info, up, down, left, right, select, red, green, yellow, blue, chanup, chandown, prev, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, dash, enter
    def initialize(params = {})
      @ip       = params[:ip]
      @port     = params[:port] || 8080
      @path     = "http://#{@ip}:#{@port}/"
      @name     = params[:name]
      @model    = params[:model]
    end
    def change_channel(channel)
      # channel = channel == channel.to_i ? channel : Directv::Channels.const_get(channel.to_sym)
      request("tv/tune?major=#{channel}")
    end
    def get_channel
      request('tv/getTuned')['callsign']
    end
    def get_program_info(channel, time = Time.now)
      request("tv/getProgInfo?major=#{channel}&time=#{time.to_i}")
    end
    def send_key(key)
      request("remote/processKey?key=#{key}")
    end
    def key_previous
      send_key('prev')
    end
    def request(url)
      puts @path + url
      uri = URI.parse(@path + url)
      i = 0
      begin
        # ok!
        res = Net::HTTP.get_response(uri)
        raise unless res.code == '200'
        JSON.parse(res.body)
      rescue 
        i += 1
        retry if i < 6
      end
    end
  end
end