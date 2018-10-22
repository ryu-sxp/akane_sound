class SectionDir < UpperSectionBase
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_left]
    if @@debug_flag
      @dir = '/media/winhdd/music/'
      #@dir = '/media/winhdd/music/Unsorted/'
      #@dir = '/home/ryu/Music/Unsorted/'
      #@dir = @@config[:root_dir]
    else
      @dir = @@config[:root_dir]
    end
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @dir_stack = Array.new
    @dir_stack.push @dir
    @dir_stack = @@save_data[:dir_stack] if @@save_data[:dir_stack]
    @tracks = 0
    @playlist = set_playlist(@dir, false)
    @tracks_played = 0
    @playlist_state = nil
    @cache_flag = false
    @pointer = @@save_data[:pointer_left]
    @page = @@save_data[:page_left]
    @offset_left = 8
    @offset_right = 4
    @title = @dir
    super
  end

  def update
    super
    if @focus_flag
      if @@inp.refresh == 1
        @pointer = 0
        @playlist = set_playlist(@dir_stack.join(nil), true)
        update_element_strings
        set_page
        update_element_positions
      end
    end
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir, refresh)
    set_status("Loading directory playlist from cache...")
    #cache_name = File.join(@@pref_dir, "cache",
    #                       dir.gsub(/\//,'-')[1..-2] + '.yaml')
    cache = File.join(dir, ".akane_cache.yaml")
    #Util.p cache
    if File.exist?(cache) && !refresh
      ar = YAML.load(File.open(cache))
      set_status("Playlist loaded.")
      return ar
    end
    set_status("Setting up directory playlist...")
    ar = Array.new
    dir_contents_dir = Dir.entries(dir).sort.select do |entry|
      if dir == @@config[:root_dir]
        File.directory?(File.join(dir, entry)) and
          !(entry == '.' || entry == '..')
      else
        File.directory?(File.join(dir, entry)) and
          !(entry == '.')
      end
    end
    dir_contents_dir.each do |entry|
      ar.push({ filename: entry+'/', dir_flag: true, duration: nil, bps: nil,
                br: nil, artist: nil, album: nil, pl_time: nil, type: nil,
                tag: nil, title: nil, pl_flag: false })
    end
    dir_contents_file = Dir.entries(dir).sort.select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.mp3|ogg|m4a|wav|mid|flac\z/ === entry)
    end
    dir_contents_file.each do |entry|
      dur = %x( mediainfo --Inform="Audio;%Duration%" "#{dir+entry}" )
      bps = %x( mediainfo --Inform="Audio;%BitRate%" "#{dir+entry}" )
      br  = %x( mediainfo --Inform="Audio;%BitRate_Mode%" "#{dir+entry}" )
      artist = %x(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      album = %x(ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      title = %x(ffprobe -loglevel error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "#{dir+entry}" )
      artist.delete!("\n")
      title.delete!("\n")
      album.delete!("\n")
      pltime = Util.ms_to_time_str(dur.to_i)
      type = entry[-3..-1].upcase
      tag = '['+pltime+'|'+type+']'
      ar.push({ filename: entry, dir_flag: false, duration: dur.to_i,
                bps: bps.to_i, br: br[0..2], artist: artist, album: album,
                pl_time: pltime, type: type, tag: tag, title: title,
                pl_flag: false })
      @tracks += 1
    end
    dir_contents_pl = Dir.entries(dir).sort.select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.apl.yaml\z/ === entry)
    end
    dir_contents_pl.each do |entry|
      ar.push({ filename: entry+'/', dir_flag: false, duration: nil, bps: nil,
                br: nil, artist: nil, album: nil, pl_time: nil, type: nil,
                tag: nil, title: nil, pl_flag: true })
    end
    # write cache
    File.open(cache, 'w') { |file| file.write(ar.to_yaml) }

    #p ar.to_s if @@debug_flag
    set_status("Playlist set.")
    return ar
  end

end
