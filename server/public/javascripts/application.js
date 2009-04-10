var trace = function(message) {
  console.log(message);
};

var initCamera = function(snapshotUrl) {
  swfobject.embedSWF('/swfs/camera.swf', 'camera', 320, 240, '9.0.0', null, {snapshotUrl: snapshotUrl});
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