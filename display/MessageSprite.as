package {
  import flash.display.Loader;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class MessageSprite extends Sprite {
    private var text:TextField;
    private var imageLoader:Loader;

    public function MessageSprite(message:Object, textFormat:TextFormat) {
      var background:Shape = new Shape();
      background.x = 10;
      addChild(background);

      text = new TextField();
      text.x = 190;
      text.y = 10;
      text.defaultTextFormat = textFormat;
      text.text = message.text;
      text.width = 440;
      text.wordWrap = true;
      text.height = text.textHeight + 5;
      addChild(text);

      background.graphics.beginFill(0xCCCCCC);
      background.graphics.drawRect(0, 0, 620, offsetHeight);
      background.graphics.endFill();

      if (message.snapshot_id) {
        imageLoader = new Loader();
        imageLoader.x = 20;
        imageLoader.y = 10;
        imageLoader.scaleX = imageLoader.scaleY = 0.5;
        imageLoader.load(new URLRequest('http://localhost:3000/snapshots/' + message.snapshot_id + '.png'));
        addChild(imageLoader);
      }
      else {
        var imagePlaceholder:Shape = new Shape();
        imagePlaceholder.x = 20;
        imagePlaceholder.y = 10;
        imagePlaceholder.graphics.beginFill(0x333333);
        imagePlaceholder.graphics.drawRect(0, 0, 160, 120);
        imagePlaceholder.graphics.endFill();
        addChild(imagePlaceholder);
      }
    }

    public function get offsetHeight() {
      return Math.max(text.textHeight, 120) + 20;
    }
  }
}