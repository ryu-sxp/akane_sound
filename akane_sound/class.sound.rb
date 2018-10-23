class Sound < Akane
  attr_accessor :volume, :track, :mode
  def initialize
    @track = nil
    @tstmp_play_start = nil
    @volume = @@save_data[:volume]
    @mode = { next: @@save_data[:next], repeat: @@save_data[:repeat],
              shuffle: @@save_data[:shuffle] }
  end

  def set_track
  end

  def play_track
  end

  def toggle_shuffle
    if @mode[:shuffle]
      @mode[:shuffle] = false
    else
      @mode[:shuffle] = true
    end
  end

  def toggle_repeat
    if @mode[:repeat]
      @mode[:repeat] = false
    else
      @mode[:repeat] = true
    end
  end
  def toggle_next
    if @mode[:next]
      @mode[:next] = false
    else
      @mode[:next] = true
    end
  end

  def set_vol
    SDL2::Mixer::MusicChannel.volume = @volume
  end
end
