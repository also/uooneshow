package com.ryanberdeen.oneshow.feed {
  import com.adobe.serialization.json.JSON;
  import com.ryanberdeen.oneshow.Main;

  import fl.transitions.Tween;
  import fl.transitions.easing.Regular;

  import flash.display.BlendMode;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.utils.Timer;

  public class LiveMessageSprite extends Sprite {
    private var text:TextField;
    private var textFormat:TextFormat;
    private var background:Shape;
    private var timer:Timer;
    private var alphaTween:Tween;

    public function LiveMessageSprite() {
      Main.connector.subscribe('feed', this);

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 22;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      background = new Shape();

      background.graphics.beginFill(0x999999);
      background.graphics.drawRect(0, 0, 100, 100);
      background.graphics.endFill();
      addChild(background);

      alpha = 0;
    }

    public function handle_new_message(message:String):void {
      if (text != null) {
        removeChild(text);
      }

      var o:Object = JSON.decode(message);
      text = new TextField();
      text.blendMode = BlendMode.LAYER;
      text.cacheAsBitmap = true;
      text.x = 10;
      text.y = 10;
      text.width = 400;
      text.alpha = .2;

      text.defaultTextFormat = textFormat;
      addChild(text);

      text.text = o.text;
      text.height = text.textHeight + 5;

      background.width = 420;
      background.height = Math.max(200, text.textHeight + 20);
      alpha = .6;

      timer = new Timer(5000, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();
    }

    public function timerHandler(e:Event):void {
      removeChild(text);
      alphaTween = new Tween(this, 'alpha', Regular.easeInOut, alpha, 0, 1, true);
    }
  }
}
