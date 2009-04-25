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
    private var top:Sprite;
    private var bottom:Sprite;
    private var messages:Array;
    private var messageHeights:Array;
    private var bottomIndex:int;
    private var currentMessageLength:int;
    private var currentIndex:int;

    public function MessageVerticalScroller() {
      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      messages = [];
      messageHeights = [];
    }

      private function get topHeight():int {
        return Math.max(top != null ? top.height : 0, stage.stageHeight);
      }

      private function get bottomHeight():int {
        return Math.max(bottom.height, stage.stageHeight);
      }

    private function start():void {
      trace('starting');
      started = true;
      currentIndex = 0;
      bottomIndex = 0;
      currentMessageLength = messages.length;
      // start off empty
      bottom = new Sprite();
      nextScreen();
      advance();
    }

    private function nextScreen():void {
      trace('next set')
      top = bottom;
      var scrollOffset:int = topHeight - stage.stageHeight;
      top.y = 0;
      scrollRect = new Rectangle(0, scrollOffset, stage.stageWidth, stage.stageHeight);
      bottom = new Sprite();
      bottom.y = topHeight;
      addChild(bottom);
      refill();
    }

    private function refill():void {
      var messageY:int = 0;

      while (messageY <= stage.stageHeight && bottomIndex < currentMessageLength) {
        var messageSprite:MessageSprite = new MessageSprite(messages[bottomIndex], textFormat);
        messageSprite.y = messageY;
        bottom.addChild(messageSprite);
        messageHeights[bottomIndex] = messageSprite.offsetHeight;
        messageY += messageSprite.offsetHeight + 10;
        bottomIndex++;
      }
    }

    private function advance():void {

      if (currentIndex <= currentMessageLength) {
        var scrollEndY:int;
        if (currentIndex == currentMessageLength) {
          trace('scrolling last message off screen');
          scrollEndY = bottomHeight;
        }
        else {
          trace('advancing to message ' + currentIndex);
          scrollEndY = scrollY + messageHeights[currentIndex];
        }
        currentIndex++;

        trace('scrolling from ' + scrollY + ' to ' + scrollEndY);
        var tween:Tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollY, scrollEndY, 1, true);
        tween.addEventListener('motionFinish', advanceEnd);
        tween.addEventListener('motionChange', tweenWtf);
        tween.addEventListener('motionStop', tweenWtf);
        tween.addEventListener('motionStop', tweenWtf);
        tween.addEventListener('motionStop', tweenWtf);
        tween.addEventListener('motionStop', tweenWtf);
      }
      else {
        trace('advanced past last message');
        start();
      }
    }

    private function tweenWtf(e:Event):void {
      //trace(e.type);
      //trace(new Error().getStackTrace());
    }

    private function advanceEnd(e:Event):void {
      var timer:Timer = new Timer(2000, 1);
      timer.addEventListener('timer', scrollTime);
      timer.start();
    }

    private function scrollTime(e:Event):void {
      advance();
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
      messages[messages.length] = messageEvent.message;
      if (!started) {
        start();
      }
    }
  }
}
