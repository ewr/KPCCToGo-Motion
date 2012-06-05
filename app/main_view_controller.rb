class MainViewController < UIViewController
  attr_accessor :downloadView, :playView, :downloadProgress, 
    :downloadProgressLabel, :playView, :playButton, :playProgress, 
    :freshAtLabel
  
  def viewDidLoad
    puts "#{self.to_s}: MainView viewDidLoad"
    
    @player = GrabAndGoPlayer.sharedPlayer()
    @defaults = NSUserDefaults.standardUserDefaults
    
    # hide download view
    @downloadView.alpha = 0
    
    # hide player view
    if !@player.hasAudio?
      @playView.alpha = 0
    end
    
    # register a timer listener to update play status
    @player.registerTimerListener do |av|
      @playProgress.progress = av.currentTime / av.duration
    end
  end
  
  def prepareForSegue(segue, sender:sender)
    if segue.identifier == "showAlternate"
      optsView = segue.destinationViewController
      optsView.set_on_done(lambda do |view|
        view.dismissModalViewControllerAnimated(true)
      end)
    end
  end
  
  #----------
  
  def grabAudioButtonPushed(sender)
    # initialize our progress indicators
    @downloadProgressLabel.text = ""
    @downloadProgress.progress = 0
    
    reqDate = Time.now()
    
    @player.grab_audio(minutes:@defaults['duration'],topOfHour:@defaults['top_of_hour'],
      complete:lambda do
        # re-enable the grab button
        sender.enabled = true
        
        # hide the download view
        @downloadView.alpha = 0
        
        # set our "Fresh at" date
        @freshAtLabel.text = reqDate.strftime("%a, %-l:%M%p")
        
        # show the player view
        @playView.alpha = 1
      end,
      progress:lambda do |bytes,totalBytes,expectedBytes|
        puts "progress: #{totalBytes.to_f / expectedBytes}"
        @downloadProgress.progress = totalBytes.to_f / expectedBytes
        @downloadProgressLabel.text = sprintf("%.0f bytes of %.0f",totalBytes,expectedBytes)
      end
    )
    
    # disable download button
    sender.enabled = false
    
    # display download view
    @downloadView.alpha = 1
  end
  
  #----------
  
  def playButtonPushed(sender)
    if @player.togglePlay()
      if @player.player.playing?
        sender.titleLabel.text = "Stop"
      else
        sender.titleLabel.text = "Play"
      end
    else
      sender.titleLabel.text = "Error"
    end
  end
  
  #----------
end