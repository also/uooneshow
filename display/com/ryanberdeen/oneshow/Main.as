package com.ryanberdeen.oneshow {
  import com.ryanberdeen.oneshow.feed.FeedMainSprite;
  import com.ryanberdeen.oneshow.feed.LiveMessageSprite;
  import com.ryanberdeen.oneshow.reel.ReelSprite;
  import com.ryanberdeen.oneshow.support.Connector;
  import com.ryanberdeen.oneshow.support.ItemsReceivedEvent;
  import com.ryanberdeen.oneshow.support.Monitor;

  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    public static var baseUrl:String;

    private var feedSprite:FeedMainSprite;
    public static var feedMonitor:Monitor;
    public static var connector:Connector;

    public function Main() {
      var options:Object = root.loaderInfo.parameters;
      Main.baseUrl = options.baseUrl || 'http://localhost:3000/';

      connector = new Connector();
      connector.connect('localhost', 1843);

      var background:Shape = new Shape();
      background.graphics.beginFill(0xdbddde);
      background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      background.graphics.endFill();
      addChild(background);

      var reelSprite:ReelSprite = new ReelSprite(550, 490);
      reelSprite.x = 240;
      reelSprite.y = 60;
      addChild(reelSprite);

      feedSprite = new FeedMainSprite(240, 490);
      feedSprite.y = 60;
      addChild(feedSprite);

      feedMonitor = new Monitor(Main.baseUrl +  'feed_items.json', 'feed_items', options.monitorInterval || 5000);
      feedMonitor.addEventListener(ItemsReceivedEvent.TYPE, feedSprite.itemsReceived);
      feedMonitor.start();

      var liveMessage:Sprite = new LiveMessageSprite();
      liveMessage.x = 100;
      liveMessage.y = 100;
      addChild(liveMessage);
    }
  }
}
