class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # -- load a shared player instance -- #
    
    @player = GrabAndGoPlayer.sharedPlayer()
    @player.saveURL = NSURL.fileURLWithPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)[0],"pump.mp3"].join("/")
    #@player.saveURL = NSURL.fileURLWithPath [App.documents_path,"pump.mp3"].join('/')
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    storyboard = UIStoryboard.storyboardWithName("MainStoryboard_iPhone", bundle:nil)
    rootVC = storyboard.instantiateViewControllerWithIdentifier("MainView")

    @window.rootViewController = rootVC
    @window.makeKeyAndVisible
    true
  end
end
