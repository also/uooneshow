package {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.Font;
  import flash.text.TextFormat;
  import flash.media.Camera;
  import flash.media.Video;

  public class Main extends Sprite {
    private var messageSprite:Sprite;

    private var messageY:int;
    private var textFormat:TextFormat;
    private var monitor:Monitor;
    private var camera:Camera;
    private var video:Video;

    public function Main() {
      monitor = new Monitor(this);

      camera = Camera.getCamera();
      camera.setMode(640, 480, 28);
      video = new Video(640, 480);
      video.attachCamera(camera);
      addChild(video);

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0xFFFFFF;
      textFormat.bold = true;

      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);

      reset();
    }

    private function reset():void {
      messageSprite = new Sprite();
      messageSprite.x = 10;
      addChild(messageSprite);
      messageY = 480;
    }

    public function addMessage(string:String):void {
      var message:Message;
      message = new Message(string, textFormat);
      message.y = messageY;
      messageSprite.addChild(message);
      messageY += message.textHeight + 10;
    }

    private function onEnterFrame(e:Event):void {
      messageSprite.y--;
      if (-messageSprite.y > messageY) {
        messageSprite.y = 0;
      }
    }

    private function addedToStage(e:Event):void {
      monitor.update();
    }
  }
}
