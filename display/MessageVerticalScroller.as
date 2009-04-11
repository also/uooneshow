package {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.TextFormat;

  class MessageVerticalScroller extends Sprite {
    private var messageY:int;
    private var textFormat:TextFormat;

    public function MessageVerticalScroller() {
      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function addedToStage(e:Event):void {
      reset();
    }

    public function reset():void {
      scrollRect = new Rectangle(0, -stage.stageHeight, stage.stageWidth, stage.stageHeight);
      messageY = 0;
    }

    public function addMessage(message:Object):void {
      var messageSprite:MessageSprite = new MessageSprite(message, textFormat);
      messageSprite.y = messageY;
      addChild(messageSprite);
      messageY += messageSprite.offsetHeight + 30;
    }

    private function onEnterFrame(e:Event):void {
      var rect:Rectangle = scrollRect;
      rect.y += 2;
      if (rect.y > messageY) {
        rect.y = -stage.stageHeight;
      }
      scrollRect = rect;
    }
  }
}
