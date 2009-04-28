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

    private var items:Array;
    private var currentItemSprite:Sprite;
    private var nextItemSprite:Sprite;
    private var currentItemIndex:int;
    private var timer:Timer;

    private var timeExpired:Boolean;
    private var nextItemReady:Boolean;

    private var itemDisplayTime:int = 5000;
    private var jsonLoader:JsonLoader;

    public function ReelSprite(displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;

      var background:Shape = new Shape();
      background.graphics.beginFill(0);
      background.graphics.drawRect(0, 0, displayWidth, displayHeight);
      background.graphics.endFill();
      addChild(background);

      jsonLoader = new JsonLoader(Main.baseUrl + 'reel_items.json', reelItemsLoaded);
      jsonLoader.load();
    }

    private function start():void {
      currentItemIndex = -1;
      timeExpired = true;
      prepareNextItem();
    }

    private function reelItemsLoaded(result:Object):void {
      items = result.reel_items;
      start();
    }

    public function itemReady():void {
      nextItemReady = true;
      if (timeExpired) {
        advance();
      }
    }

    public function itemFinished():void {

    }

    private function prepareNextItem():void {
      nextItemReady = false;
      currentItemIndex = (currentItemIndex + 1) % items.length;

      var item:Object = items[currentItemIndex];

      switch(item.media_type) {
        case 'image':
          nextItemSprite = new FeaturedImageSprite(item, this, displayWidth, displayHeight);
          break;
        case 'video':
          nextItemSprite = new FeaturedVideoSprite(item, this, displayWidth, displayHeight);
          break;
        default:
          // TODO
      }
    }

    private function advance():void {
      if (currentItemSprite != null) {
        ReelItem(currentItemSprite).stop();
        removeChild(currentItemSprite);
      }

      currentItemSprite = nextItemSprite;
      addChild(currentItemSprite);
      ReelItem(currentItemSprite).start();

      timeExpired = false;
      timer = new Timer(ReelItem(currentItemSprite).nominalTime, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();

      prepareNextItem();
    }

    private function timerHandler(e:Event):void {
      timer = null;
      timeExpired = true;
      if (nextItemReady) {
        advance();
      }
    }
  }
}
