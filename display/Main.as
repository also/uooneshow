package {
  import flash.display.Sprite;
  import flash.events.Event;

  public class Main extends Sprite {
    private var messages:MessageVerticalScroller;
    private var monitor:Monitor;

    public function Main() {
      messages = new MessageVerticalScroller();
      addChild(messages);

      monitor = new Monitor(this);
      monitor.update();
    }

    public function addMessage(message:Object):void {
      messages.addMessage(message);
    }
  }
}
