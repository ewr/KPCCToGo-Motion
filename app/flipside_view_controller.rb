class FlipsideViewController < UIViewController
  attr_accessor :delegate, :duration, :topOfHour, :durationLabel
  
  def viewDidLoad
    puts "#{self.to_s}: FlipsideView viewDidLoad"
    @defaults = NSUserDefaults.standardUserDefaults
    
    if v = @defaults.objectForKey("duration")
      @duration.value = v
    end
    
    if v = @defaults.objectForKey("top_of_hour")
      @topOfHour.on = v
    end
    
    # set duration text
    self.durationChanged(@duration)
  end
  
  def set_on_done(vc)
    puts "setting on_done to ", vc
    @on_done = vc
  end
  
  
  def durationChanged(sender)
    @durationLabel.text = sprintf("%.0f Minutes", sender.value)
  end
  
  #----------
  
  def topOfHourChanged(sender)
    puts "topOfHourChanged #{sender}"
  end
  
  #----------
  
  def done(sender)
    @defaults.setFloat(@duration.value,forKey:"duration")
    @defaults.setBool(@topOfHour.on?,forKey:"top_of_hour")
    @on_done && @on_done.call(self)
  end
end