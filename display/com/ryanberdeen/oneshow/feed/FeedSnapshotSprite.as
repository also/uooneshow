package com.ryanberdeen.oneshow.feed {
  import com.ryanberdeen.oneshow.Main;

  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.geom.Point;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  public class FeedSnapshotSprite extends FeedItemSprite {
    private static const PADDING:int = 10;
    private static const HIGHLIGHT_BORDER_WIDTH:int = PADDING / 2;
    private static const ORIGINAL_IMAGE_WIDTH:int = 640;
    private static const ORIGINAL_IMAGE_HEIGHT:int = 480;

    private var text:TextField;
    private var imageUrl:String;
    private var imageLoader:Loader;
    private var imageHeight:Number;

    public function FeedSnapshotSprite(itemData:Object, textFormat:TextFormat, displayWidth:int) {
      cacheAsBitmap = true;

      var innerWidth:Number = displayWidth - PADDING * 4;
      var imageScale:Number = innerWidth / ORIGINAL_IMAGE_WIDTH;
      imageHeight = ORIGINAL_IMAGE_HEIGHT * imageScale;

      var background:Shape = new Shape();
      background.x = PADDING;
      addChild(background);


      text = new TextField();
      text.x = PADDING * 2;
      text.y = PADDING;
      text.defaultTextFormat = textFormat;
      text.text = itemData.text;
      text.width = innerWidth;
      text.wordWrap = true;
      text.height = text.textHeight + 5;
      addChild(text);

      background.graphics.beginFill(0xCCCCCC);
      background.graphics.drawRect(0, 0, displayWidth - PADDING * 2, offsetHeight);
      background.graphics.endFill();

      // TODO null images?
      if (itemData.image_url) {
        imageUrl = Main.resolveUrl(itemData.image_url)

        imageLoader = new Loader();
        imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        imageLoader.x = PADDING * 2;
        imageLoader.y = text.textHeight + PADDING * 2;
        imageLoader.scaleX = imageLoader.scaleY = imageScale;
        imageLoader.load(new URLRequest(imageUrl));
        addChild(imageLoader);
      }
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
      // TODO display placeholder?
    }

    private function completeHandler(e:Event):void {
      Bitmap(imageLoader.content).smoothing = true;
    }

    override public function get offsetHeight():int {
      return text.textHeight + imageHeight + PADDING * 3;
    }
  }
}
