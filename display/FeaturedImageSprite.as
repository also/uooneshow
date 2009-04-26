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
    private var titleText:TextField;
    private var creditText:TextField;
    private var linkText:TextField;

    public function FeaturedImageSprite(image:Object, displayWidth:int, displayHeight:int) {
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;
      imageLoader = new Loader();
      imageLoader.load(new URLRequest(image.image_url));
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      addChild(imageLoader);

      var textBackground:Shape = new Shape();
      // TODO dimension
      textBackground.y = displayHeight - 70;
      addChild(textBackground);

      titleText = new TextField();
      //titleText.defaultTextFormat = textFormat;
      titleText.text = image.title;
      // TODO dimension
      titleText.width = displayWidth;
      titleText.height = titleText.textHeight + 5;
      // TODO dimension
      titleText.x = 20;
      titleText.y = displayHeight - 60;
      addChild(titleText);

      creditText = new TextField();
      //creditText.defaultTextFormat = textFormat;
      creditText.text = image.credit;
      // TODO dimension
      creditText.width = displayWidth;
      creditText.height = creditText.textHeight + 5;
      // TODO dimension
      creditText.x = 20;
      creditText.y = displayHeight - 40;
      addChild(creditText);

      linkText = new TextField();
      //linkText.defaultTextFormat = textFormat;
      linkText.text = image.url;
      // TODO dimension
      linkText.width = displayWidth;
      linkText.height = linkText.textHeight + 5;
      // TODO dimension
      linkText.x = 20;
      linkText.y = displayHeight - 20;
      addChild(linkText);

      var textWidth = Math.max(titleText.textWidth, creditText.textWidth, linkText.textWidth) + 40;

      textBackground.graphics.beginFill(0xFFFFFF);
      // TODO dimension
      textBackground.graphics.drawRect(0, 0, textWidth, 70);
      textBackground.graphics.endFill();
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
