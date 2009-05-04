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

  public class FeedMessageSprite extends FeedItemSprite {
    private static const PADDING:int = 10;
    private static const IMAGE_WIDTH:int = 48;
    private static const IMAGE_HEIGHT:int = 48;

    private var message:Object;
    private var text:TextField;
    private var imageUrl:String;
    private var imageLoader:Loader;
    private var backgroundHighlight:Shape;

    public function FeedMessageSprite(message:Object, textFormat:TextFormat, displayWidth:int) {
      cacheAsBitmap = true;
      var background:Shape = new Shape();
      background.x = PADDING;
      addChild(background);

      if (message.profile_image_url) {
        imageUrl = message.profile_image_url;
      }

      if (imageUrl) {
        imageLoader = new Loader();
        imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        imageLoader.x = PADDING * 2;
        imageLoader.y = PADDING;
        //imageLoader.scaleX = imageLoader.scaleY = 0.5;
        imageLoader.load(new URLRequest(imageUrl));
        addChild(imageLoader);
      }

      text = new TextField();
      text.x = PADDING * 2;
      text.y = PADDING;
      text.width = displayWidth - PADDING * 4;
      if (imageUrl) {
        text.x += IMAGE_WIDTH + PADDING;
        text.width -= IMAGE_WIDTH + PADDING;
      }
      text.defaultTextFormat = textFormat;
      text.text = message.text;
      text.wordWrap = true;
      text.height = text.textHeight + 5;
      addChild(text);

      background.graphics.beginFill(0xCCCCCC);
      background.graphics.drawRect(0, 0, displayWidth - PADDING * 2, offsetHeight);
      background.graphics.endFill();
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
      // TODO display placeholder?
    }

    private function completeHandler(e:Event):void {
      Bitmap(imageLoader.content).smoothing = true;
    }

    override public function get offsetHeight():int {
      return Math.max(text.textHeight, IMAGE_HEIGHT) + PADDING * 2;
    }
  }
}
