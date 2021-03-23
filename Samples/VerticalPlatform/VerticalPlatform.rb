class VerticalPlatform
    attr_gtk
  
    def s
      state.vertical_platform ||= state.new_entity(:vertical_platform)
      state.vertical_platform
    end
  
    def new_platform hash
      s.new_entity_strict(:platform, hash)
    end
  
    def tick
      defaults
      render
      input
      calc
    end
  
    def defaults
      s.platforms ||= [new_platform(x: 200, y: 100, w: 150, h: 32, dy: 1, speed: 5, rect: [0,0,0,0], previous_rect: [0,0,0,0], next_rect: [0,0,0,0]),
                        new_platform(x: 400, y: 300, w: 150, h: 32, dy: 1, speed: 5, rect: [0,0,0,0], previous_rect: [0,0,0,0], next_rect: [0,0,0,0])]
      s.tick_count = args.state.tick_count
      s.visible_platforms = [*s.platforms]
      s.gravity = -0.3
      s.bridge_top = 64
      s.player.x ||= 0
      s.player.y ||= s.bridge_top
      s.player.w ||= 64
      s.player.h ||= 64
      s.player.dy ||= 0
      s.player.dx ||= 0
      s.player_jump_power = 15
      s.player_jump_power_duration  = 10
      s.player_max_run_speed        = 5
      s.player_speed_slowdown_rate  = 0.9
      s.player_acceleration         = 1
      s.camera ||= { x: -100}
    end
  
    def render_visible_platforms
      s.visible_platforms = s.platforms.find_all { |p| p.x > (s.player.x - 300) }
      outputs.solids << s.visible_platforms.map do |p|
        [p.x - s.camera[:x], p.y, p.w, p.h, 255, 0, 0]
      end
  
      outputs.solids << {
          x: s.player.x - s.camera[:x], # player positioned on top of platform
          y: s.player.y,
          w: s.player.w,
          h: s.player.h,
          r: 100,              # color saturation
          g: 300,
          b: 100
        }
    end
    def render_platforms
      outputs[:mini_map].width = 10000
      outputs[:mini_map].solids << [s.x, s.y, s.w, s.h, 255, 0, 0]
      outputs[:mini_map].solids << 40.map_with_index do |i| 
        [i * 32, s.bridge_top - 32, 32, 32, 0, 0, 0, 30]
      end
      
      args.outputs[:mini_map].borders << [s.player.x, s.player.y, s.player.w, s.player.h]
  
      args.outputs[:mini_map].borders << s.platforms.map do |p|
        [p.x, p.y, p.w, p.h]
      end
  
      outputs[:mini_map].solids << s.platforms.map do |p|
        [p.x, p.y, p.w, p.h, 0, 0, 0, 30]
      end
      
      outputs[:mini_map].solids << {
          x: s.player.x, # player positioned on top of platform
          y: s.player.y,
          w: s.player.w,
          h: s.player.h,
          r: 100,              # color saturation
          g: 100,
          b: 200
        }
  
      outputs[:mini_map].labels << [s.player.x, s.player.y + 85, s.player.dy]
      outputs[:mini_map].labels << [s.player.x, s.player.y + 105, s.player.y]
      outputs[:mini_map].labels << s.platforms.map do |p| [
        [p.x, p.y, p.rect.to_s],
        [p.x, p.y - 20, p.previous_rect.to_s],
        [p.x, p.y - 40, p.next_rect.to_s]
      ]
      end
      
      outputs.sprites << [0, 0, 10000 * 0.4, 720 * 0.4, :mini_map]
    end
  
    def render
      render_visible_platforms
      #render_platforms
    end
    
    def move_spawn
      delta = (s.player.x - s.camera[:x] - 100)
  
      if delta > -200
        s.camera[:x] += delta * 0.1
        s.player.x += s.player.dx
  
        has_platforms = s.platforms.find_all { |p| p.x > (s.player.x + 300) }
        if has_platforms.length == 0 
          last_platform = s.platforms[-1]
          s.platforms << new_platform(x: last_platform.x + 300,
                                      y: 200 * rand,
                                      w: 150,
                                      h: 32,
                                      dy: 1,
                                      speed: 5, 
                                      rect: [0,0,0,0], previous_rect: [0,0,0,0], next_rect: [0,0,0,0])
        end
      end
    end
  
    def calc
  
      s.player.point = [s.player.x + s.player.w.half, s.player.y]
  
      collision = s.platforms.find { |p| (s.player.point.inside_rect? p.previous_rect) || (s.player.point.inside_rect? p.rect) || (s.player.point.inside_rect? p.next_rect)}
  
      s.platforms.each do |p|  
        p.previous_rect = [p.rect.x, p.rect.y, p.rect.w, p.rect.h]
      end
      
      s.player.x += s.player.dx
  
      s.platforms.each do |p|
        p.rect = [p.x, p.y, p.w, p.h]
  
        p.y += p.dy * p.speed
      
        if p.y < 100
          p.dy *= -1
          p.y = 100
        elsif p.y > (500 - p.h)
          p.dy *= -1
          p.y = (500 - p.h)
        end
        p.next_rect = [p.x, p.y, p.w, p.h]
        if p.next_rect.y < 100
          p.next_rect.dy *= -1
          p.next_rect.y = 100
        elsif p.next_rect.y > (500 - p.h)
          p.next_rect.dy *= -1
          p.next_rect.y = (500 - p.h)
        end
      end
  
      if collision && s.player.dy <= 0
  
        s.player.platform = collision
      
        s.player.dy = 0
  
        s.player.y = collision.rect.y + 32 + collision.dy * collision.speed
        s.player.platform = collision
      else
        s.player.on_platform = false
        s.player.platform = nil
      end
  
      if !s.player.platform
        s.player.dy += s.gravity
      else 
        s.player.dy = 0
      end
      
      s.player.y += s.player.dy
  
      s.player.y = s.player.y.greater(s.bridge_top)
  
    move_spawn
    end
  
      def input
        if inputs.keyboard.space
          s.player.jumped_at ||= s.tick_count
          s.player.dy = s.player_jump_power
          
        end 
  
        if inputs.keyboard.left
          s.player.dx -= s.player_acceleration
          s.player.dx = s.player.dx.greater(-s.player_max_run_speed)
        elsif inputs.keyboard.right
          s.player.dx += s.player_acceleration
          s.player.dx = s.player.dx.lesser(s.player_max_run_speed)
        else
          s.player.dx *= s.player_speed_slowdown_rate
        end
      end
    end
  
    $game = VerticalPlatform.new
  
    def tick args
      $game.args = args
      $game.tick
    end