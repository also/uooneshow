package {
  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.TextFormat;
  import flash.utils.Timer;

  class MessageVerticalScroller extends Sprite {
    private var messageY:int = 0;
    private var textFormat:TextFormat;
    private var childIndex:int = 0;
    private var started:Boolean = false;

    public function MessageVerticalScroller() {
      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0x333333;
      textFormat.bold = true;
    }

    public function reset():void {
      scrollRect = new Rectangle(0, -stage.stageHeight + 30, stage.stageWidth, stage.stageHeight);
      scroll();
      started = true;
    }

    private function scroll():void {
      var scrollEndY:int = messageY;
      if (childIndex < numChildren) {
        var sprite:MessageSprite = MessageSprite(getChildAt(childIndex++));
        scrollEndY = scrollRect.y + sprite.offsetHeight + 30;
      }
      var tween:Tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollRect.y, scrollEndY, 1, true);
      tween.addEventListener('motionFinish', scrollEnd);
    }

    private function scrollEnd(e:Event):void {
      if (scrollY >= messageY) {
        scrollY = -stage.stageHeight + 30;
        childIndex = 0;
      }
      var timer:Timer = new Timer(2000, 1);
      timer.addEventListener('timer', scrollTime);
      timer.start();
    }

    private function scrollTime(e:Event):void {
      scroll();
    }

    public function set scrollY(value):void {
      var rect:Rectangle = scrollRect;
      rect.y = value;
      scrollRect = rect;
    }

    public function get scrollY():int {
      return scrollRect.y;
    }

    public function messageReceived(messageEvent:MessageReceivedEvent):void {
      var messageSprite:MessageSprite = new MessageSprite(messageEvent.message, textFormat);
      messageSprite.y = messageY;
      addChild(messageSprite);
      messageY += messageSprite.offsetHeight + 30;
      if (!started) {
        reset();
      }
    }
  }
}
