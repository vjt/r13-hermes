$(function () {
  $('a[data-toggler]').on('change', function (event) {
    var toggler = $(this);
    var togglee = $(toggler.data('target')).first();
    var visible = togglee.is(':visible');

    if (!visible)
      toggler.addClass('expanded');
    else
      toggler.removeClass('expanded');

    togglee.toggle();
    toggler.trigger({type: 'toggled', togglee: toglee, visible: visible});

    return true;
  });

  $('[data-toggle-group]').on('change', 'input[type=radio]', function (event) {
    var input = $(this);
    var group = input.closest('[data-toggle-group]');

    // Hide others
    group.find('[data-togglee]').hide();

    // Show this
    var target = input.data('toggle');
    if (target)
      $(target).show();
  });
});
