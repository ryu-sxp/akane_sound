#!/home/ryu/.rvm/rubies/ruby-2.5.1/bin/ruby
require "sdl2"

file = ARGV[0]

SDL2.init(SDL2::INIT_TIMER|SDL2::INIT_AUDIO|SDL2::INIT_VIDEO|
          SDL2::INIT_EVENTS)
SDL2::Mixer.init(SDL2::Mixer::INIT_FLAC|SDL2::Mixer::INIT_MODPLUG|
                 SDL2::Mixer::INIT_MP3|SDL2::Mixer::INIT_OGG)
SDL2::Mixer.open(44100, SDL2::Mixer::DEFAULT_FORMAT, 2, 512)

music = SDL2::Mixer::Music.load(file)

p music.inspect

info = %x( mediainfo "#{file}" )

p info



