package {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    public static var baseUrl:String;

    private var messageTicker:MessageTicker;
    private var feedSprite:FeedMainSprite;
    private var monitor:Monitor;
    public static var connector:Connector;

    public function Main() {
      var options:Object = root.loaderInfo.parameters;
      Main.baseUrl = options.baseUrl || 'http://localhost:3000/';

      connector = new Connector();
      connector.connect('localhost', 1843);

      var featuredImage:FeaturedImageSprite = new FeaturedImageSprite({
        image_url: 'http://static.ryanberdeen.com/ryanberdeen.com/i/top.jpg',
        title: 'a tree',
        credit: 'Somebody so sxc.hu',
        url: 'http://ryanberdeen.com'
      }, 640, 430);
      addChild(featuredImage);

      feedSprite = new FeedMainSprite(640, 480);
      //addChild(feedSprite);

      var tickerBackground:Shape = new Shape();
      tickerBackground.y = stage.stageHeight - 50;
      tickerBackground.graphics.beginFill(0x333333);
      tickerBackground.graphics.drawRect(0, 0, stage.stageWidth, 50);
      tickerBackground.graphics.endFill();
      addChild(tickerBackground);

      messageTicker = new MessageTicker();
      messageTicker.y = stage.stageHeight - 45;
      addChild(messageTicker);

      monitor = new Monitor(options.monitorInterval || 5000);
      monitor.addEventListener(MessageReceivedEvent.TYPE, feedSprite.messageReceived);
      monitor.addEventListener(MessageReceivedEvent.TYPE, messageTicker.messageReceived);
      monitor.start();
    }
  }
}
