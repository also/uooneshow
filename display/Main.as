package {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.Font;
  import flash.text.TextFormat;
  import flash.media.Camera;
  import flash.media.Video;

  public class Main extends Sprite {
    private var messagesSprite:Sprite;

    private var messageY:int;
    private var textFormat:TextFormat;
    private var monitor:Monitor;
    private var camera:Camera;
    private var video:Video;

    public function Main() {
      monitor = new Monitor(this);

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);

      reset();
    }

    private function reset():void {
      messagesSprite = new Sprite();
      messagesSprite.scrollRect = new Rectangle(0, -stage.stageHeight, stage.stageWidth, stage.stageHeight);
      messagesSprite.cacheAsBitmap = true;
      messagesSprite.x = 10;
      addChild(messagesSprite);
      messageY = 0;
    }

    public function addMessage(message:Object):void {
      var messageSprite:MessageSprite = new MessageSprite(message, textFormat);
      messageSprite.y = messageY;
      messagesSprite.addChild(messageSprite);
      messageY += messageSprite.offsetHeight + 30;
      messagesSprite.height = messagesSprite.height;
    }

    private function onEnterFrame(e:Event):void {
      var rect:Rectangle = messagesSprite.scrollRect;
      rect.y += 2;
      if (rect.y > messageY) {
        rect.y = -stage.stageHeight;
      }
      messagesSprite.scrollRect = rect;
    }

    private function addedToStage(e:Event):void {
      monitor.update();
    }
  }
}
