class SectionDir < UpperSectionBase
  def initialize(x, y, w, h, col)
    @focus_flag = @@save_data[:focus_left]
    if @@debug_flag
      @dir = '/media/winhdd/music/Unsorted/'
      #@dir = '/home/ryu/Music/Unsorted/'
    else
      @dir = @@config[:root_dir]
    end
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @tracks = 0
    @playlist = set_playlist(@dir, false)
    @tracks_played = 0
    @playlist_state = nil
    @cache_flag = false
    @pointer = @@save_data[:pointer_left]
    super
  end

  def update
    super
  end

  def update_size(x, y, w, h)
    super
  end
  
  def draw
    super
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir, refresh)
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
                tag: nil, title: nil })
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
                pl_time: pltime, type: type, tag: tag, title: title })
      @tracks += 1
    end
    p ar.to_s if @@debug_flag
    return ar
  end

end
