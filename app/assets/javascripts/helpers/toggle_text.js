$.fn.extend({
  toggleText: function (a, b){
    if (this.text() == a){ this.text(b); }
    else { this.text(a) }
  }
});
