package com.ryanberdeen.oneshow.reel {
  import com.ryanberdeen.oneshow.Main;
  import com.ryanberdeen.oneshow.support.JsonLoader;

  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.utils.Timer;

  public class ReelSprite extends Sprite implements ReelController {
    private var displayWidth:int;
    private var displayHeight:int;
    private var creditSprite:FeaturedItemCreditSprite;

    public var items:Array;
    private var currentItem:Object;
    private var currentPartSprite:Sprite;
    private var nextPartSprite:Sprite;
    private var currentItemIndex:int;
    private var currentPartIndex:int;
    private var timer:Timer;

    private var timeExpired:Boolean;
    private var nextPartReady:Boolean;
    private var currentPartFinished:Boolean;

    private var partDisplayTime:int = 5000;
    private var jsonLoader:JsonLoader;

    public function ReelSprite(displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;

      jsonLoader = new JsonLoader(Main.baseUrl + 'reel_items.json', reelItemsLoaded);
      jsonLoader.load();

      Main.connector.subscribe('reel', this);
    }

    private function start():void {
      currentItemIndex = 0;
      currentItem = items[0];
      currentPartIndex = -1;
      timeExpired = true;
      prepareNextPart();
    }

    public function pause():void {
      ReelItem(currentPartSprite).pause();
      if (timer != null) {
        //timer.pause();
      }
    }

    public function resume():void {
      ReelItem(currentPartSprite).resume();
      if (timer != null) {
        //timer.resume();
      }
    }

    private function reelItemsLoaded(result:Object):void {
      items = result.reel_items;
      start();
    }

    public function partReady():void {
      nextPartReady = true;
      if (timeExpired) {
        advance();
      }
    }

    public function partFinished():void {
      //currentPartFinished = true;
      //if (timer != null) {
      //  timer.stop();
      //}
      //timerHandler(null);
    }

    private function timerHandler(e:Event):void {
      timer = null;
      timeExpired = true;
      if (nextPartReady) {
        advance();
      }
    }

    private function prepareNextPart():void {
      nextPartReady = false;
      if (++currentPartIndex >= currentItem.parts.length) {
        currentItemIndex = (currentItemIndex + 1) % items.length;
        currentItem = items[currentItemIndex];
        currentPartIndex = 0;
      }
      var part:Object = currentItem.parts[currentPartIndex];
      trace('currentItemIndex: ' + currentItemIndex);
      trace('currentPartIndex: ' + currentPartIndex);

      switch(part.media_type) {
        case 'image':
          nextPartSprite = new FeaturedImageSprite(part, this, displayWidth, displayHeight);
          break;
        case 'video':
          nextPartSprite = new FeaturedVideoSprite(part, this, displayWidth, displayHeight);
          break;
        default:
          // TODO
      }
    }

    private function advance():void {
      if (currentPartSprite != null) {
        ReelItem(currentPartSprite).stop();
        removeChild(currentPartSprite);
        removeChild(creditSprite);
      }

      currentPartSprite = nextPartSprite;
      addChild(currentPartSprite);
      ReelItem(currentPartSprite).start();

      creditSprite = new FeaturedItemCreditSprite(currentItem, displayWidth);
      creditSprite.alpha = 0.5;
      creditSprite.y = displayHeight - creditSprite.height;
      addChild(creditSprite);

      timeExpired = false;
      timer = new Timer(ReelItem(currentPartSprite).nominalTime, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();

      prepareNextPart();
    }

    public function stop():void {
      if (timer != null) {
        timer.stop();
      }
      ReelItem(currentPartSprite).stop();
    }
  }
}
