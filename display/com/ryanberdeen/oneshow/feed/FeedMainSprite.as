package com.ryanberdeen.oneshow.feed {
  import com.ryanberdeen.oneshow.Main;
  import com.ryanberdeen.oneshow.support.ItemsReceivedEvent;

  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.TextFormat;
  import flash.utils.Timer;

  public class FeedMainSprite extends Sprite {
    private var displayWidth:int;
    private var displayHeight:int;
    private var textFormat:TextFormat;
    private var started:Boolean = false;
    private var top:Sprite;
    private var bottom:Sprite;
    private var feedItems:Array;
    private var feedItemHeights:Array;
    // TODO rename. these shouldn't seem like they apply only to the _bottom_ sprite
    private var bottomIndex:int;
    private var bottomY:int;
    private var currentFeedItemCount:int;
    private var currentIndex:int;
    // JESUS FUCKING CHRIST ADOBE, WHY DIDN'T YOU DOCUMENT THE FACT THAT NO HARD REFERENCES
    // TO THE TWEEN ARE HELD SO IT WILL BE GARBAGE COLLECTED UNLESS I PUT IT IN THIS HERE
    // CLASS VARIABLE.
    private var tween:Tween;

    private var feedItemSpacing:int = 10;
    private var feedItemDisplayTime:int = 4000;
    private var feedItemScrollSpeed:int = 200; // speed in pixels/secon

    public function FeedMainSprite(displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;

      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 14;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      feedItems = [];
      feedItemHeights = [];
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
      currentFeedItemCount = feedItems.length;

      // start off empty
      bottom = new Sprite();
      addChild(bottom);
      nextSet();
      advance();
    }

    private function restart():void {
      started = false;
      if (top != null) {
        removeChild(top);
        top = null;
      }
      if (bottom != null) {
        removeChild(bottom);
        bottom = null;
      }
      start();
    }

    private function nextSet():void {
      if (top != null) {
        removeChild(top);
      }
      top = bottom;
      var scrollOffset:int = topHeight - displayHeight;
      top.y = 0;
      scrollRect = new Rectangle(0, scrollOffset, displayWidth, displayHeight);
      bottom = new Sprite();
      bottom.y = topHeight + feedItemSpacing;
      addChild(bottom);
      refill();
    }

    private function refill():void {
      bottomY = 0;
      while (bottomY <= displayHeight && bottomIndex < currentFeedItemCount) {
        var feedItem:Object = feedItems[bottomIndex];
        var feedItemSprite:FeedItemSprite;
        switch (feedItem.source) {
          case 'snapshot':
          case 'flickr':
            feedItemSprite = new FeedSnapshotSprite(feedItem, textFormat, displayWidth);
            break;
          default:
            feedItemSprite = new FeedMessageSprite(feedItem, textFormat, displayWidth);
        }

        feedItemSprite.y = bottomY;
        bottom.addChild(feedItemSprite);
        feedItemHeights[bottomIndex] = feedItemSprite.offsetHeight;
        bottomY += feedItemSprite.offsetHeight + feedItemSpacing;
        bottomIndex++;
      }
    }

    private function advance():void {
      if (currentIndex <= currentFeedItemCount) {
        if (currentIndex < currentFeedItemCount && currentIndex == bottomIndex) {
          nextSet();
        }
        var scrollEndY:int;
        if (currentIndex == currentFeedItemCount) {
          // scrolling last feed item off screen
          scrollEndY = topHeight + bottomY;
        }
        else {
          scrollEndY = scrollY + feedItemHeights[currentIndex] + feedItemSpacing;
        }
        currentIndex++;

        tween = new Tween(this, 'scrollY', Regular.easeInOut, scrollY, scrollEndY, (scrollEndY - scrollY) / feedItemScrollSpeed, true);
        tween.addEventListener('motionFinish', advanceEnd);
        //scrollY = scrollEndY;
        //advanceEnd(null);
      }
      else {
        // advanced past last feed item
        restart();
      }
    }

    private function advanceEnd(e:Event):void {
      tween = null;
      var timer:Timer = new Timer(feedItemDisplayTime, 1);
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

    public function itemsReceived(e:ItemsReceivedEvent):void {
      feedItems = e.items;
      if (!started) {
        start();
      }
    }
  }
}
