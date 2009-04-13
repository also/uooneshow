package {
  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.Loader;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class MessageSprite extends Sprite {
    private static const PADDING:int = 10;
    private static const HIGHLIGHT_BORDER_WIDTH:int = PADDING / 2;
    private static const IMAGE_WIDTH:int = 160;
    private static const IMAGE_HEIGHT:int = 120;
    private static const WIDTH:int = 640;

    private var message:Object;
    private var text:TextField;
    private var imageLoader:Loader;
    private var backgroundHighlight:Shape;
    private var highlightTween:Tween;

    public function MessageSprite(message:Object, textFormat:TextFormat) {
      var background:Shape = new Shape();
      background.x = PADDING;
      addChild(background);

      backgroundHighlight = new Shape();
      backgroundHighlight.x = PADDING;
      backgroundHighlight.alpha = 0;
      addChild(backgroundHighlight);

      text = new TextField();
      text.x = IMAGE_WIDTH + PADDING * 3;
      text.y = PADDING;
      text.defaultTextFormat = textFormat;
      text.text = message.text;
      text.width = WIDTH - IMAGE_WIDTH - PADDING * 5;
      text.wordWrap = true;
      text.height = text.textHeight + 5;
      addChild(text);

      background.graphics.beginFill(0xCCCCCC);
      background.graphics.drawRect(0, 0, text.width + IMAGE_WIDTH + PADDING * 3, offsetHeight);
      background.graphics.endFill();

      backgroundHighlight.graphics.beginFill(0xFFFFFF);
      backgroundHighlight.graphics.drawRect(
        HIGHLIGHT_BORDER_WIDTH, HIGHLIGHT_BORDER_WIDTH,
        background.width - HIGHLIGHT_BORDER_WIDTH * 2, background.height - HIGHLIGHT_BORDER_WIDTH * 2);
      backgroundHighlight.graphics.endFill();

      if (message.snapshot_id) {
        imageLoader = new Loader();
        imageLoader.x = PADDING * 2;
        imageLoader.y = PADDING;
        imageLoader.scaleX = imageLoader.scaleY = 0.5;
        imageLoader.load(new URLRequest(Main.baseUrl + 'snapshots/' + message.snapshot_id + '.png'));
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

      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function get offsetHeight() {
      return Math.max(text.textHeight, IMAGE_HEIGHT) + PADDING * 2;
    }

    public function set highlight(value:Boolean) {
      if (value) {
        highlightTween = new Tween(backgroundHighlight, 'alpha', Regular.easeInOut, 0, 1, 1, true);
      }
      else {
        highlightTween.yoyo();
        highlightTween = null;
      }
    }

    private function onEnterFrame(e:Event):void {
      var y:int = globalToLocal(new Point(0, 320)).y;
      if (y > 0 && y < offsetHeight && highlightTween == null) {
        highlight = true;
      }
      else if (y >= offsetHeight && highlightTween != null) {
        highlight = false;
      }
    }
  }
}
