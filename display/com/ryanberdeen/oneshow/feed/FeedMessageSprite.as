package com.ryanberdeen.oneshow.feed {
  import com.ryanberdeen.oneshow.Main;

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
    private static const HIGHLIGHT_BORDER_WIDTH:int = PADDING / 2;
    private static const IMAGE_WIDTH:int = 50;
    private static const IMAGE_HEIGHT:int = 50;

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

      text = new TextField();
      text.x = IMAGE_WIDTH + PADDING * 3;
      text.y = PADDING;
      text.defaultTextFormat = textFormat;
      text.text = message.text;
      text.width = displayWidth - IMAGE_WIDTH - PADDING * 5;
      text.wordWrap = true;
      text.height = text.textHeight + 5;
      addChild(text);

      background.graphics.beginFill(0xCCCCCC);
      background.graphics.drawRect(0, 0, text.width + IMAGE_WIDTH + PADDING * 3, offsetHeight);
      background.graphics.endFill();

      if (message.snapshot_id) {
        imageUrl = Main.baseUrl + 'snapshots/' + message.snapshot_id + '.png';
      }
      else if (message.profile_image_url) {
        imageUrl = message.profile_image_url;
      }

      if (imageUrl) {
        imageLoader = new Loader();
        imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        imageLoader.x = PADDING * 2;
        imageLoader.y = PADDING;
        //imageLoader.scaleX = imageLoader.scaleY = 0.5;
        imageLoader.load(new URLRequest(imageUrl));
        addChild(imageLoader);
      }
      else {
        var imagePlaceholder:Shape = new Shape();
        imagePlaceholder.x = PADDING * 2;
        imagePlaceholder.y = PADDING;
        imagePlaceholder.graphics.beginFill(0x333333);
        imagePlaceholder.graphics.drawRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
        imagePlaceholder.graphics.endFill();
        addChild(imagePlaceholder);
      }
    }

    private function ioErrorHandler(e:IOErrorEvent):void {
      // TODO display placeholder?
    }

    override public function get offsetHeight():int {
      return Math.max(text.textHeight, IMAGE_HEIGHT) + PADDING * 2;
    }
  }
}
