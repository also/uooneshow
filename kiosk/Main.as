package {
  import com.adobe.images.PNGEncoder;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Camera;
  import flash.media.Video;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestHeader;
  import flash.net.URLRequestMethod;
  import flash.utils.ByteArray;

  public class Main extends Sprite {
    private var camera:Camera;
    private var video:Video;

    public function Main() {
      camera = Camera.getCamera();
      camera.setMode(320, 240, 29);
      video = new Video(320, 240);
      addChild(video);
      video.attachCamera(camera);

      stage.addEventListener(MouseEvent.CLICK, onClick);
    }

    private function captureSnapshot():ByteArray {
      var bitmap:BitmapData = new BitmapData(320, 240);
      bitmap.draw(video);
      return PNGEncoder.encode(bitmap);
    }

    private function sendSnapshot(bytes:ByteArray):void {
      var request:URLRequest = new URLRequest('http://localhost:3000/snapshots');
      request.method = URLRequestMethod.POST;
      request.requestHeaders = [new URLRequestHeader("Content-Type", "image/png")];
      request.data = bytes;

      var loader:URLLoader = new URLLoader();
      loader.load(request);
    }

    private function onClick(e:MouseEvent):void {
      var bytes:ByteArray = captureSnapshot();

      sendSnapshot(bytes);
    }
  }
}
