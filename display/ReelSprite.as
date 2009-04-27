package {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.utils.Timer;

  class ReelSprite extends Sprite {
    private var displayWidth:int;
    private var displayHeight:int;

    private var items:Array;
    private var currentItemSprite:Sprite;
    private var nextItemSprite:Sprite;
    private var currentItemIndex:int;
    private var timer:Timer;

    private var itemDisplayTime:int = 5000;
    private var jsonLoader:JsonLoader;

    public function ReelSprite(displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;

      jsonLoader = new JsonLoader(Main.baseUrl + 'reel_items.json', reelItemsLoaded);
      jsonLoader.load();
    }

    private function start():void {
      currentItemIndex = -1;
      prepareNextItem();
      advance();
    }

    private function reelItemsLoaded(result:Object):void {
      items = result.reel_items;
      start();
    }

    private function prepareNextItem():void {
      currentItemIndex = (currentItemIndex + 1) % items.length;

      var item:Object = items[currentItemIndex];

      switch(item.media_type) {
        case 'image':
          nextItemSprite = new FeaturedImageSprite(item, displayWidth, displayHeight);
          break;
        case 'video':
          nextItemSprite = new FeaturedVideoSprite(item, displayWidth, displayHeight);
          break;
        default:
          // TODO
      }
    }

    private function advance():void {
      if (currentItemSprite != null) {
        removeChild(currentItemSprite);
      }

      currentItemSprite = nextItemSprite;
      addChild(currentItemSprite);

      timer = new Timer(itemDisplayTime, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();

      prepareNextItem();
    }

    private function timerHandler(e:Event):void {
      timer = null;
      advance();
    }
  }
}
