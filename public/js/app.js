/**
 * @credits to http://bootswatch.com/js/application.js
 */
(function ($) {

  $(function(){

    // fix sub nav on scroll
    var $win = $(window),
        $nav = $('.subnav'),
        navHeight = $('.navbar').first().height(),
        navTop = $('.subnav').length && $('.subnav').offset().top - navHeight,
        isFixed = 0;

    processScroll();

    $win.on('scroll', processScroll);

    function processScroll() {
      var i, scrollTop = $win.scrollTop();
      if (scrollTop >= navTop && !isFixed) {
        isFixed = 1;
        $nav.addClass('subnav-fixed');
        if ($(window).width() >= 980) {
          $('.surprise-title').show();
        }
      } else if (scrollTop <= navTop && isFixed) {
        isFixed = 0;
        $nav.removeClass('subnav-fixed');
        if ($(window).width() >= 980) {
          $('.surprise-title').hide();
        }
      }
    }

  });

})(window.jQuery);