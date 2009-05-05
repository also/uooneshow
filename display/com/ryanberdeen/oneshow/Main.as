package com.ryanberdeen.oneshow {
  import com.ryanberdeen.oneshow.feed.FeedMainSprite;
  import com.ryanberdeen.oneshow.feed.LiveMessageSprite;
  import com.ryanberdeen.oneshow.reel.ReelSprite;
  import com.ryanberdeen.oneshow.support.Connector;
  import com.ryanberdeen.oneshow.support.ItemsReceivedEvent;
  import com.ryanberdeen.oneshow.support.Monitor;

  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;

  public class Main extends Sprite {
    private static const HEADER_HEIGHT:Number = 60;
    private static const BODY_HEIGHT:Number = 490;

    private static const STATE_MAIN = 'main';
    private static const STATE_FULLSCREEN = 'fullscreen';
    private static const STATE_INTERMEDIATE = 'intermediate';
    private var tween:Tween;
    private var state:String;
    public static var baseUrl:String;

    private var feedSprite:FeedMainSprite;
    private var reelSprite:ReelSprite;
    private var liveMessageSprite:LiveMessageSprite;
    public static var feedMonitor:Monitor;
    public static var connector:Connector;
    public static var options:Object;

    public function Main() {
      options = root.loaderInfo.parameters;
      Main.baseUrl = options.baseUrl || 'http://localhost:3000/';

      opaqueBackground = 0xdbddde;

      var headerSprite:HeaderSprite = new HeaderSprite();

      headerSprite.x = stage.stageWidth - 10 - headerSprite.width;
      headerSprite.y = 10;

      addChild(headerSprite);
      
      var footerSprite:FooterSprite = new FooterSprite();
      footerSprite.x = 10;
      footerSprite.y = stage.stageHeight - footerSprite.height - 10;
      addChild(footerSprite);

      start();
    }

    public function get scrollY():int {
      return scrollRect.y;
    }

    public function set scrollY(value):void {
      var rect:Rectangle = scrollRect;
      rect.y = value;
      scrollRect = rect;
    }

    private function start():void {
      connector = new Connector();
      connector.connect(options.connectorHost || 'localhost', options.connectorPort || 1843);

      reelSprite = new ReelSprite(550, BODY_HEIGHT);
      reelSprite.x = 240;
      reelSprite.y = HEADER_HEIGHT;
      addChildAt(reelSprite, 0);

      feedSprite = new FeedMainSprite(240, BODY_HEIGHT + HEADER_HEIGHT);
      feedSprite.y = 0;
      addChild(feedSprite);

      feedMonitor = new Monitor(Main.baseUrl +  'feed_items.json', 'feed_items', options.monitorInterval || 5000);
      feedMonitor.addEventListener(ItemsReceivedEvent.TYPE, feedSprite.itemsReceived);
      feedMonitor.start();

      liveMessageSprite = new LiveMessageSprite(stage.stageWidth, stage.stageHeight - HEADER_HEIGHT - BODY_HEIGHT);
      liveMessageSprite.y = HEADER_HEIGHT + BODY_HEIGHT;
      addChild(liveMessageSprite);

      connector.subscribe('controller', this);
      scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
      state = STATE_MAIN;
    }

    public function handle_show_fullscreen(message:String) {
      state = STATE_INTERMEDIATE;
      tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollY, HEADER_HEIGHT - stage.stageHeight, 2, true);
      //tween.addEventListener('motionFinish', fullscreenTweenEndHandler);
    }

    public function handle_show_main(message:String) {
      state = STATE_INTERMEDIATE;
      tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollY, 0, 2, true);
      //tween.addEventListener('motionFinish', mainTweenEndHandler);
    }

    public function handle_reset(message:String):void {
      reset();
    }

    public function handle_stop(message:String):void {
      stop();
    }

    private function reset():void {
      connector.close();
      feedMonitor.stop();
      stop();
      start();
    }

    private function stop():void {
      reelSprite.stop();
      feedSprite.stop();
      removeChild(reelSprite);
      removeChild(feedSprite);
      removeChild(liveMessageSprite);
    }

    public static function resolveUrl(url:String):String {
      if (url.indexOf('http') != 0) {
        url = baseUrl.substring(0, baseUrl.length - 1) + url;
      }
      return url;
    }
  }
}
