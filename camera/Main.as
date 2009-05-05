package {
  import com.adobe.images.PNGEncoder;
  import com.adobe.serialization.json.JSON;

  import flash.display.BitmapData;
  import flash.display.Graphics;
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
    private var snapshotGraphics:Graphics;
    private var showingSnapshot:Boolean;

    private var loader:URLLoader;
    private var snapshotUrl:String;

    public function Main() {
      snapshotUrl = root.loaderInfo.parameters.snapshotUrl;
      camera = Camera.getCamera();
      camera.setMode(640, 480, 29);
      video = new Video(640, 480);
      addChild(video);
      video.attachCamera(camera);

      var snapshotSprite:Sprite = new Sprite();
      addChild(snapshotSprite);
      snapshotGraphics = snapshotSprite.graphics;
      snapshotSprite.scaleX = -1;
      snapshotSprite.x = 640;

      showingSnapshot = false;

      stage.addEventListener(MouseEvent.CLICK, onClick);

      ExternalInterface.addCallback('takeSnapshot', takeSnapshot);
      ExternalInterface.addCallback('takeSnapshot', clearSnapshot);
      ExternalInterface.addCallback('showCameraSettings', showCameraSettings);
      ExternalInterface.addCallback('showPrivacySettings', showPrivacySettings);
      ExternalInterface.addCallback('setReversed', setReversed);
      setReversed(true);
    }

    private function showCameraSettings():void {
      Security.showSettings(SecurityPanel.CAMERA);
    }

    private function showPrivacySettings():void {
      Security.showSettings(SecurityPanel.PRIVACY);
    }

    private function setReversed(reversed:Boolean):void {
      if (reversed) {
        video.scaleX = -1;
        video.x = video.width;
      }
      else {
        video.scaleX = 1;
        video.x = 0;
      }
    }

    private function captureSnapshot():BitmapData {
      var bitmap:BitmapData = new BitmapData(640, 480);
      bitmap.draw(video);
      return bitmap;
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

    private function clearSnapshot():void {
      snapshotGraphics.clear();
      showingSnapshot = false;
    }

    private function showSnapshot(bitmap:BitmapData):void {
      clearSnapshot();
      snapshotGraphics.beginBitmapFill(bitmap);
      snapshotGraphics.drawRect(0, 0, bitmap.width, bitmap.height);
      snapshotGraphics.endFill();
      showingSnapshot = true;
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
      if (!showingSnapshot) {
        takeSnapshot();
      }
      else {
        clearSnapshot();
      }
    }

    private function takeSnapshot():Boolean {
      if (loader != null) {
        return false; // a snapshot is being sent
      }
      var bitmap:BitmapData = captureSnapshot();
      var bytes:ByteArray = PNGEncoder.encode(bitmap);

      showSnapshot(bitmap);

      sendSnapshot(bytes);
      return true;
    }

    private function snapshotPosted(snapshot:Object):void {
      ExternalInterface.call('snapshotPosted', snapshot);
    }
  }
}
