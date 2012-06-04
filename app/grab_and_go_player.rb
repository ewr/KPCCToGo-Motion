class GrabAndGoPlayer < AFHTTPClient
  @@shared = nil
  
  def self.sharedPlayer
    return @@shared unless @@shared.nil?
    @@shared = GrabAndGoPlayer.alloc.initWithBaseURL(NSURL.URLWithString("http://localhost:8015/kpcclive"))
    @@shared.setDefaultHeader("Accept",value:"audio/mpeg")
    @@shared.setDefaultHeader("User-Agent",value:"KPCC Grab-N-Go 0.2")
    
    @@shared.activityManager = AFNetworkActivityIndicatorManager.sharedManager
    @@shared.activityManager.enabled = true
    @@shared
  end
  
  #----------
  
  attr_accessor :pumpURL, :saveURL, :activityManager, :_isDownloading, :_player
  
  def player
    @_player ||= AVAudioPlayer.alloc.initWithContentsOfURL(@saveURL,error:nil)
  end
  
  #----------
  
  def hasAudio?
    self._player ? true : false
  end
  
  #----------
  
  def togglePlay
    return false if !self.player
    
    if self.player.playing?
      self.player.stop()
    else
      self.player.play()
    end
  end
  
  #----------
  
  def grab_audio(args)
    return false if self._isDownloading
    
    reqDate = NSDate.date()
    
    success = Proc.new do |op,res|
      self._isDownloading = false
      puts "success"
      
      args[:complete].call if args[:complete]
    end
    
    failure = Proc.new do |op,err|
      self._isDownloading = false
      puts "failure"
    end
    
    request = self.requestWithMethod("GET",path:"",parameters:{ :pump => args[:minutes] * 60 })
    
    op = self.HTTPRequestOperationWithRequest(request,success:success,failure:failure)
    op.outputStream = NSOutputStream.outputStreamWithURL(@saveURL,append:false)
    self.enqueueHTTPRequestOperation op
    
    if args[:progress]
      op.setDownloadProgressBlock args[:progress]
    end
    
    self._isDownloading = true
  end

end