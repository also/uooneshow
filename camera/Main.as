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
  import flash.external.ExternalInterface;
  import flash.media.Camera;
  import flash.media.Video;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestHeader;
  import flash.net.URLRequestMethod;
  import flash.system.SecurityPanel;
  import flash.system.Security;
  import flash.utils.ByteArray;

  public class Main extends Sprite {
    private var camera:Camera;
    private var video:Video;

    private var loader:URLLoader;
    private var snapshotUrl:String;

    public function Main() {
      snapshotUrl = root.loaderInfo.parameters.snapshotUrl;
      camera = Camera.getCamera();
      camera.setMode(640, 480, 29);
      video = new Video(640, 480);
      addChild(video);
      video.attachCamera(camera);
      trace('camera muted:' + camera.muted);

      stage.addEventListener(MouseEvent.CLICK, onClick);

      ExternalInterface.addCallback('takeSnapshot', takeSnapshot);
      ExternalInterface.addCallback('showCameraSettings', showCameraSettings);
      ExternalInterface.addCallback('showPrivacySettings', showPrivacySettings);
    }

    private function showCameraSettings():void {
      Security.showSettings(SecurityPanel.CAMERA);
    }

    private function showPrivacySettings():void {
      Security.showSettings(SecurityPanel.PRIVACY);
    }

    private function captureSnapshot():ByteArray {
      var bitmap:BitmapData = new BitmapData(640, 480);
      bitmap.draw(video);
      return PNGEncoder.encode(bitmap);
    }

    private function sendSnapshot(bytes:ByteArray):void {
      // TODO show error if snapshot url is null
      var request:URLRequest = new URLRequest(snapshotUrl);
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
      var snapshot:Object = JSON.decode(loader.data);
      loader = null;
      snapshotPosted(snapshot);
    }

    private function progressHandler(event:ProgressEvent):void {
      // TODO indicate progress?
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
      errorHandler(event);
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
      if (event.status != 200) {
        // TODO why is status 0?
        //errorHandler(event);
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
      takeSnapshot();
    }

    private function takeSnapshot():Boolean {
      if (loader != null) {
        trace('ignoring click while posting snapshot');
        return false; // a snapshot is being sent
      }
      var bytes:ByteArray = captureSnapshot();

      sendSnapshot(bytes);
      return true;
    }

    private function snapshotPosted(snapshot:Object):void {
      trace('snapshot posted: ' + snapshot.id);
      ExternalInterface.call('snapshotPosted', snapshot);
    }
  }
}
