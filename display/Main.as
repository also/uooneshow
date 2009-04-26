package {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    public static var baseUrl:String;

    private var messageTicker:MessageTicker;
    private var messageScroller:MessageVerticalScroller;
    private var monitor:Monitor;
    public static var connector:Connector;

    public function Main() {
      var options:Object = root.loaderInfo.parameters;
      Main.baseUrl = options.baseUrl || 'http://localhost:3000/';

      connector = new Connector();
      connector.connect('localhost', 1843);

      messageScroller = new MessageVerticalScroller();
      addChild(messageScroller);

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
      monitor.addEventListener(MessageReceivedEvent.TYPE, messageScroller.messageReceived);
      monitor.addEventListener(MessageReceivedEvent.TYPE, messageTicker.messageReceived);
      monitor.start();
    }
  }
}
