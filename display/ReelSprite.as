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

    public function ReelSprite(displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;
      // TODO dynamic
      items = [
        {
          image_url: 'http://static.ryanberdeen.com/ryanberdeen.com/i/top.jpg',
          title: 'a tree',
          credit: 'Somebody from sxc.hu',
          url: 'http://ryanberdeen.com'
        },
        {
          image_url: 'http://static.ryanberdeen.com/ryanberdeen.com/i/bottom.jpg',
          title: 'some grass',
          credit: 'same as the tree',
          url: 'http://oneshow.ryanberdeen.com'
        }
      ];

      currentItemIndex = -1;
      prepareNextItem();
      advance();
    }

    private function prepareNextItem():void {
      currentItemIndex = (currentItemIndex + 1) % items.length;

      nextItemSprite = new FeaturedImageSprite(items[currentItemIndex], displayWidth, displayHeight);
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