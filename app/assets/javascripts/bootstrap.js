$(function () {
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
  $("input.datepicker").datepicker({
                                      format: "yyyy-mm-dd"
  });
});
