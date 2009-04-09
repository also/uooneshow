var trace = function(message) {
  console.log(message);
};

var initCamera = function() {
  swfobject.embedSWF('/swfs/kiosk.swf', 'camera', 320, 240, '9.0.0', null, null, {allowScriptAccess: 'true'});
  $('snapshot').observe('click', function(event) {
    event.stop();
    $('camera').takeSnapshot();
  });
};

var snapshotPosted = function(snapshot) {
  console.log(snapshot);
  $('snapshot').update(new Element('img', {src: '/snapshots/' + snapshot.id + '.png'}));
  $('message_snapshot_id').value = snapshot.id;
};