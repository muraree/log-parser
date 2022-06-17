class Player
  attr_accessor :name, :kill_times, :no_world_kill_times, :world_kill_times 
  
  def initializer(name, kill_times = 0, no_world_kill_times = 0, world_kill_times = 0)
    @name = name
    @kill_times = kill_times
    @no_world_kill_times = no_world_kill_times
    @world_kill_times = world_kill_times
  end

  def kill(player)
    if self == player || @name == "<world>"
      player.world_kill_times += 1
    else
      @kill_times += 1
      player.no_world_kill_times += 1
    end
  end

  def get_score
    @kill_times - @world_kill_times
  end
end