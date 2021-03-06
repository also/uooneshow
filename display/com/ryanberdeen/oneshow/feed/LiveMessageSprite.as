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
    private var message:Array;
    private var displayWidth:Number;

    public function LiveMessageSprite(displayWidth:Number, displayHeight:Number) {
      this.displayWidth = displayWidth;
      Main.connector.subscribe('feed', this);

      textFormat = new TextFormat();
      textFormat.font = 'Rockwell';
      textFormat.size = 22;
      textFormat.color = 0xffffff;
      //textFormat.bold = true;

      background = new Shape();
      background.graphics.beginFill(0x0070FF);
      background.graphics.drawRect(0, 0, displayWidth, displayHeight);
      background.graphics.endFill();
      addChild(background);

      alpha = 0;
    }

    public function handle_new_message(message:String):void {
      if (text != null) {
        removeChild(text);
      }
      if (alphaTween != null) {
        alphaTween.stop();
        alphaTween = null;
        if (timer != null) {
          timer.stop();
          timer = null;
        }
      }

      var o:Object = JSON.decode(message);
      text = new TextField();
      text.blendMode = BlendMode.LAYER;
      text.cacheAsBitmap = true;
      text.x = 10;
      text.y = 10;
      text.width = displayWidth - 20;
      text.alpha = .2;

      text.defaultTextFormat = textFormat;
      addChild(text);

      text.text = o.text;
      text.height = text.textHeight + 5;

      alpha = 1;

      timer = new Timer(5000, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();
    }

    public function handle_hide(message:String):void {

    }

    public function handle_show(message:String):void {

    }

    public function timerHandler(e:Event):void {
      removeChild(text);
      text = null;
      alphaTween = new Tween(this, 'alpha', Regular.easeInOut, alpha, 0, 1, true);
      alphaTween.addEventListener('motionFinish', alphaTweenFinishedHandler);
    }
    
    private function alphaTweenFinishedHandler(e:Event):void {
      alphaTween = null;
    }
  }
}
