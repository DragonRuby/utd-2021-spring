xrepl do

    def s
        return $game.s
    end
    delta = (s.player.x - s.camera[:x] - 100)
    puts delta
    s.camera[:x] += delta * 0.01
    puts s.camera[:x]
    puts "------------"
    has_platforms = s.platforms.find do |p| 
        puts "platforms"
        puts p
        puts "delta"
        puts delta
        puts "camera"
        puts s.camera[:x]
        p.x > (s.player.x + 300) 
    end
    puts has_platforms
  end

  repl do 
   $game.move_spawn
    def s
        return $game.s
    end
    puts "platform."
    has_platforms = s.platforms.find_all { |p| p.x > (s.player.x + 300) }
    puts has_platforms

  end