package {
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLRequest;

  class FeaturedImageSprite extends Sprite {
    private var imageLoader:Loader;

    public function FeaturedImageSprite(image:Object) {
      imageLoader = new Loader();
      imageLoader.load(new URLRequest(image.url));
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      addChild(imageLoader);
    }

    private function completeHandler(event:Event):void {
      imageLoader.content.width = 640;
      imageLoader.content.scaleY = imageLoader.content.scaleX;
    }
  }
}
