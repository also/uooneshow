var trace = function(message) {
  console.log(message);
};

var initCamera = function(snapshotUrl) {
  swfobject.embedSWF('/swfs/camera.swf', 'camera', 640, 480, '9.0.0', null, {snapshotUrl: snapshotUrl});
  $('snapshot').observe('click', function(event) {
    event.stop();
    $('camera').takeSnapshot();
  });
  $('shutter').observe('click', function(event) {
    event.stop();
    $('camera').takeSnapshot();
  });
};

var snapshotPosted = function(snapshot) {
  console.log(snapshot);
  $('snapshot').update(new Element('img', {src: '/snapshots/' + snapshot.id + '.png'}));
  $('feed_item_snapshot_id').value = snapshot.id;
};

var initLive = function(flashVars) {
  swfobject.embedSWF('/swfs/display.swf', 'live_display', 800, 600, '9.0.0', null, flashVars);
};
