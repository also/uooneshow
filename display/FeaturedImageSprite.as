package {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class FeaturedImageSprite extends Sprite {
    private var imageLoader:Loader;
    private var titleText:TextField;
    private var creditText:TextField;
    private var linkText:TextField;

    public function FeaturedImageSprite(image:Object) {
      imageLoader = new Loader();
      imageLoader.load(new URLRequest(image.image_url));
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      addChild(imageLoader);

      var textBackground:Shape = new Shape();
      // TODO dimension
      textBackground.y = 370;
      textBackground.graphics.beginFill(0xFFFFFF);
      // TODO dimension
      textBackground.graphics.drawRect(0, 0, 640, 110);
      textBackground.graphics.endFill();
      addChild(textBackground);

      titleText = new TextField();
      //titleText.defaultTextFormat = textFormat;
      titleText.text = image.title;
      // TODO dimension
      titleText.width = 640;
      titleText.height = titleText.textHeight + 5;
      // TODO dimension
      titleText.y = 380;
      addChild(titleText);

      creditText = new TextField();
      //creditText.defaultTextFormat = textFormat;
      creditText.text = image.credit;
      // TODO dimension
      creditText.width = 640;
      creditText.height = creditText.textHeight + 5;
      // TODO dimension
      creditText.y = 400;
      addChild(creditText);

      linkText = new TextField();
      //linkText.defaultTextFormat = textFormat;
      linkText.text = image.url;
      // TODO dimension
      linkText.width = 640;
      linkText.height = linkText.textHeight + 5;
      // TODO dimension
      linkText.y = 420;
      addChild(linkText);
    }

    private function completeHandler(event:Event):void {
      imageLoader.content.width = 640;
      imageLoader.content.scaleY = imageLoader.content.scaleX;
    }
  }
}
