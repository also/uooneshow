package {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    private var messageTicker:MessageTicker;
    private var messageScroller:MessageVerticalScroller;
    private var monitor:Monitor;

    public function Main() {
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
      monitor.update();
    }

    public function addMessage(message:Object):void {
      messageScroller.addMessage(message);
      messageTicker.addMessage(message);
    }
  }
}
