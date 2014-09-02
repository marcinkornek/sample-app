$.fn.extend({
  toggleValue: function (a, b){
    if (this.val() == a){ this.val(b); }
    else { this.val(a) }
  }
});

