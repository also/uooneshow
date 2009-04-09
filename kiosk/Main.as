package {
  import com.adobe.images.PNGEncoder;
  import com.adobe.serialization.json.JSON;

  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.HTTPStatusEvent;
  import flash.events.IOErrorEvent;
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

    private var loader:URLLoader;

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

      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, completeHandler);
      loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
      loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
      loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
      loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

      loader.load(request);
    }

    private function completeHandler(event:Event):void {
      var snapshot:Object = JSON.decode(loader.data).snapshot;
      snapshotPosted(snapshot);
      loader = null;
    }

    private function progressHandler(event:ProgressEvent):void {
      // TODO indicate progress?
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
      errorHandler(event);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
      if (event.status != 200) {
        errorHandler(event);
      }
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
      errorHandler(event);
    }

    private function errorHandler(event:Event):void {
      trace('error: ' + event);
      loader = null;
    }

    private function onClick(e:MouseEvent):void {
      if (loader != null) {
        trace('ignoring click while posting snapshot')
        return; // a snapshot is being sent
      }
      var bytes:ByteArray = captureSnapshot();

      sendSnapshot(bytes);
    }

    private function snapshotPosted(snapshot:Object):void {
      trace('snapshot posted: ' + snapshot.id);
    }
  }
}
