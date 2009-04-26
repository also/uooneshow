package {
  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.TextFormat;
  import flash.utils.Timer;

  class MessageVerticalScroller extends Sprite {
    private var displayHeight:int = 480;
    private var textFormat:TextFormat;
    private var started:Boolean = false;
    private var top:Sprite;
    private var bottom:Sprite;
    private var messages:Array;
    private var messageHeights:Array;
    // TODO rename. these shouldn't seem like they apply only to the _bottom_ sprite
    private var bottomIndex:int;
    private var bottomY:int;
    private var currentMessageLength:int;
    private var currentIndex:int;
    // JESUS FUCKING CHRIST ADOBE, WHY DIDN'T YOU DOCUMENT THE FACT THAT NO HARD REFERENCES
    // TO THE TWEEN ARE HELD SO IT WILL BE GARBAGE COLLECTED UNLESS I PUT IT IN THIS HERE
    // CLASS VARIABLE.
    private var tween:Tween;

    private var messageSpacing:int = 10;
    private var messageDisplayTime:int = 2000;
    private var messageScrollTime:int = 1000;

    public function MessageVerticalScroller() {
      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      messages = [];
      messageHeights = [];
      Main.connector.subscribe('feed', this);
    }

    private function get topHeight():int {
      return Math.max(top != null ? top.height : 0, displayHeight);
    }

    private function get bottomHeight():int {
      return Math.max(bottom.height, displayHeight);
    }

    private function start():void {
      started = true;
      currentIndex = 0;
      bottomIndex = 0;
      bottomY = 0;
      currentMessageLength = messages.length;

      // start off empty
      bottom = new Sprite();
      addChild(bottom);
      nextSet();
      advance();
    }

    private function nextSet():void {
      if (top != null) {
        removeChild(top);
      }
      top = bottom;
      var scrollOffset:int = topHeight - displayHeight;
      top.y = 0;
      scrollRect = new Rectangle(0, scrollOffset + messageSpacing, stage.stageWidth, displayHeight);
      bottom = new Sprite();
      bottom.y = topHeight + messageSpacing;
      addChild(bottom);
      refill();
    }

    private function refill():void {
      bottomY = 0;
      while (bottomY <= displayHeight && bottomIndex < currentMessageLength) {
        var messageSprite:MessageSprite = new MessageSprite(messages[bottomIndex], textFormat);
        messageSprite.y = bottomY;
        bottom.addChild(messageSprite);
        messageHeights[bottomIndex] = messageSprite.offsetHeight;
        bottomY += messageSprite.offsetHeight + messageSpacing;
        bottomIndex++;
      }
    }

    private function advance():void {
      if (currentIndex <= currentMessageLength) {
        if (currentIndex == bottomIndex) {
          nextSet();
        }
        var scrollEndY:int;
        if (currentIndex == currentMessageLength) {
          // scrolling last message off screen
          scrollEndY = topHeight + bottomY;
        }
        else {
          scrollEndY = scrollY + messageHeights[currentIndex] + messageSpacing;
        }
        currentIndex++;

        tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollY, scrollEndY, messageScrollTime / 1000, true);
        tween.addEventListener('motionFinish', advanceEnd);
      }
      else {
        // advanced past last message
        start();
      }
    }

    private function advanceEnd(e:Event):void {
      tween = null;
      var timer:Timer = new Timer(messageDisplayTime, 1);
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
      if (!started && messages.length == 100) {
        start();
      }
    }
  }
}
