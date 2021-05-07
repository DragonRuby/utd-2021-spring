class ShadowCaster
  attr_gtk

  def s 
    state.shadow_caster ||= state.new_entity(:shadow_caster)
    state.shadow_caster
  end

  def new_wall hash
    {x: hash.x, y: hash.y, x2: hash.x2, y2: hash.y2}
  end

  def new_shadow hash
    { x: hash.x, 
      y: hash.y, 
      x2: hash.x + hash[:radius] * hash[:angle].vector_x, 
      y2: hash.y + hash[:radius] * hash[:angle].vector_y,
      radius: hash[:radius], 
      angle: hash[:angle]
    }
  end


  def tick
    defaults
    render
    calc
    input
  end

  def defaults
    s.center_x ||= 400
    s.center_y ||= 200
    s.player_w ||= 8
    s.player_h ||= 8
    s.shadow_vector ||= 0
    s.walls ||= [ new_wall(x: 200, y: 150, x2: 500, y2: 150),
                  new_wall(x: 190, y: 170, x2: 190, y2: 470),
                  new_wall(x: 200, y: 500, x2: 500, y2: 500),
                  new_wall(x: 610, y: 190, x2: 610, y2: 490)]

    s.shadows ||=  360.map_with_index { |i| i}
                      .find_all { |i| i.zmod? 10 }
                      .map { |i| new_shadow(x: s.center_x, 
                                            y: s.center_y, 
                                            angle: i, 
                                            radius: 1) }
  end

  def render 
    
    outputs.lines << s.walls.map do |w|
      [w.x1, w.y1, w.x2, w.y2]
    end

    outputs.lines << s.shadows.map do |c|
      [c.x, c.y, c.x2, c.y2]
    end

    s.shadows.each do |c|
      INFINITY = 1/0.0
      limit = INFINITY
      closest = {}
      
      s.walls.each do |w|
        pt = point_intersection(w,c)
        if (pt != nil) 
          dis = geometry.distance(w, c)
          if (dis < limit)
            limit = dis
            closest = pt
          end
        end
      end
      
     outputs.lines << [c.x, c.y, closest.x, closest.y]
    end
  end

  def point_intersection line_one, line_two
    
    x1 = nil
    y1 = nil
    x2 = nil
    y2 = nil
    x3 = nil
    y3 = nil
    x4 = nil
    y4 = nil
  
    x1 = line_one.x
    y1 = line_one.y
    x2 = line_one.x2
    y2 = line_one.y2

    x3 = line_two.x 
    y3 = line_two.y 
    x4 = line_two.x2
    y4 = line_two.y2

    denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    return nil if denom == 0

    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
    u = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denom

    if t > 0 && t < 1 && u > 0
      pt = {x: 0, y: 0}
      pt.x = x1 + t * (x2 - x1)
      pt.y = y1 + t * (y2 - y1)
      return pt
    else
      return nil
    end
  end

  def calc

  end

  def input
    s.center_x += inputs.keyboard.left_right * 10
    s.center_y += inputs.keyboard.up_down * 10

    s.shadows = 360.map_with_index { |i| i}
                   .find_all { |i| i.zmod? 10 }
                   .map { |i| new_shadow(x: s.center_x, 
                                         y: s.center_y, 
                                         angle: i, 
                                         radius: 1) }
  end
end

$game = ShadowCaster.new

def tick args
  $game.args = args
  $game.tick
end
