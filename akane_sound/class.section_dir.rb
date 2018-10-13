class SectionDir < UpperSectionBase
  @dir = nil
  @playlist = nil
  @playlist_state = nil
  @cache_flag = false
  def initialize(x, y, w, h, col)
    super
    if @@debug_flag
      @dir = '/media/winhdd/music/Unsorted/'
    else
      @dir = @@config[:root_dir]
    end
    @dir = @@save_data[:cur_dir] if @@save_data[:cur_dir]
    @playlist = set_playlist(@dir, false)
  end

  def update
  end
  
  def draw
    super
  end

  #return: Array of Hash { filename: , dir_flag:, duration: }
  def set_playlist(dir, refresh)
    ar = Array.new
    dir_contents_dir = Dir.entries(dir).select do |entry|
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
                br: nil })
    end
    dir_contents_file = Dir.entries(dir).select do |entry|
      !File.directory?(File.join(dir, entry)) and
        (/\.mp3|ogg|m4a|wav|mid|flac\z/ === entry)
    end
    dir_contents_file.each do |entry|
      dur = %x( mediainfo --Inform="Audio;%Duration%" "#{dir+entry}" )
      bps = %x( mediainfo --Inform="Audio;%BitRate%" "#{dir+entry}" )
      br  = %x( mediainfo --Inform="Audio;%BitRate_Mode%" "#{dir+entry}" )
      ar.push({ filename: entry, dir_flag: false, duration: dur.to_i,
                bps: bps.to_i, br: br[0..2] })
    end
    p ar.to_s if @@debug_flag
    return ar
  end
end
