/*
 * MarkerLabel is an extension to marker to add a dynamic label
 *
 */
function MarkerLabel(opt_options) {
  this.setValues(opt_options);
  var span = this.span_ = document.createElement('span');
  span.style.cssText = 'position: relative; font-size: 10px; left: -50%; top: -42px; z-index:900; white-space: nowrap; padding: 2px; color: white;';
  var div = this.div_ = document.createElement('div');
  div.appendChild(span);
  div.style.cssText = 'position: absolute; display: none;';
}

MarkerLabel.prototype = new google.maps.OverlayView;

MarkerLabel.prototype.onAdd = function() {
  var pane = this.getPanes().overlayImage;
  pane.appendChild(this.div_);
  var me = this;
  this.listeners_ = [
    google.maps.event.addListener(this, 'position_changed', function() { me.draw(); }),
    google.maps.event.addListener(this, 'text_changed', function() { me.draw(); })
  ];
};

MarkerLabel.prototype.onRemove = function() {
  this.div_.parentNode.removeChild(this.div_);
  for(var i = 0; i < this.listeners_.length; i++) {
    google.maps.event.removeListener(this.listeners_[i]);
  }
};

MarkerLabel.prototype.draw = function() {
  var projection = this.getProjection();
  var position = projection.fromLatLngToDivPixel(this.get('position'));
  var div = this.div_;
  div.style.left = position.x + 'px';
  div.style.top = position.y + 'px';
  div.style.display = 'block';
  this.span_.innerHTML = this.get('label');
};

