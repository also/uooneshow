package {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    public static var baseUrl:String;

    private var messageTicker:MessageTicker;
    private var messageScroller:MessageVerticalScroller;
    private var monitor:Monitor;

    public function Main() {
      Main.baseUrl = root.loaderInfo.parameters.baseUrl || 'http://localhost:3000/';

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

      monitor = new Monitor(this);
      monitor.addEventListener(MessageReceivedEvent.TYPE, messageScroller.messageReceived);
      monitor.addEventListener(MessageReceivedEvent.TYPE, messageTicker.messageReceived);
      monitor.start();
    }
  }
}
