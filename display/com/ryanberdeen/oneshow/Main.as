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

    private static const STATE_MAIN = 'main';
    private static const STATE_FULLSCREEN = 'fullscreen';
    private static const STATE_INTERMEDIATE = 'intermediate';
    private var tween:Tween;
    private var state:String;
    public static var baseUrl:String;

    private var feedSprite:FeedMainSprite;
    public static var feedMonitor:Monitor;
    public static var connector:Connector;
    public static var options:Object;

    public function Main() {
      options = root.loaderInfo.parameters;
      Main.baseUrl = options.baseUrl || 'http://localhost:3000/';

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

      var background:Shape = new Shape();
      background.graphics.beginFill(0xdbddde);
      background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      background.graphics.endFill();
      addChild(background);

      var reelSprite:ReelSprite = new ReelSprite(550, 490);
      reelSprite.x = 240;
      reelSprite.y = HEADER_HEIGHT;
      addChild(reelSprite);

      feedSprite = new FeedMainSprite(240, 490);
      feedSprite.y = HEADER_HEIGHT;
      addChild(feedSprite);

      feedMonitor = new Monitor(Main.baseUrl +  'feed_items.json', 'feed_items', options.monitorInterval || 5000);
      feedMonitor.addEventListener(ItemsReceivedEvent.TYPE, feedSprite.itemsReceived);
      feedMonitor.start();

      var liveMessage:Sprite = new LiveMessageSprite();
      liveMessage.x = 100;
      liveMessage.y = 100;
      addChild(liveMessage);

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
  }
}
