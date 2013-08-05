//= require ./jquery-1.10.2.min.js
//= require ./bootstrap-3.0.0-rc1.min.js
//= require_tree .

ColorThief.prototype.toRGB = function(colorArray) {
  return "rgb(" + colorArray[0] + ',' + colorArray[1] + ',' + colorArray[2] + ")"
}

$.colorThief = new ColorThief()

// copied from github.com/harthur/color
$.Color.prototype.dark = function() {
  // YIQ equation from http://24ways.org/2010/calculating-color-contrast
  var rgb = this.rgba()
  var yiq = (rgb[0] * 299 + rgb[1] * 587 + rgb[2] * 114) / 1000
  return yiq < 128
}

$.Color.prototype.light = function() {
  return !this.dark()
}
