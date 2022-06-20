# frozen_string_literal: true

class Kill
  attr_reader :killer, :killed, :kill_reason

  def initialize(killer, killed, kill_reason)
    @killer = killer
    @killed = killed
    @kill_reason = kill_reason
  end
end
