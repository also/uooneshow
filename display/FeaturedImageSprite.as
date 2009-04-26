package {
  import flash.display.DisplayObject;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class FeaturedImageSprite extends Sprite {
    private var displayWidth:int;
    private var displayHeight:int;

    private var imageLoader:Loader;

    public function FeaturedImageSprite(image:Object, displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;
      imageLoader = new Loader();
      imageLoader.load(new URLRequest(image.image_url));
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      addChild(imageLoader);

      var credit:FeaturedItemCreditSprite = new FeaturedItemCreditSprite(image);
      credit.y = displayHeight - credit.height;
      addChild(credit);
    }

    private function completeHandler(event:Event):void {
      var image:DisplayObject = imageLoader.content;
      if (image.width > displayWidth) {
        image.width = displayWidth;
      }
      if (image.height > displayHeight) {
        image.height = displayHeight;
      }
      image.scaleY = image.scaleX = Math.min(image.scaleY, image.scaleX);
    }
  }
}
