jQuery(document).ready(function($) {
  /* When option change then change the grab code (for widget) */

  $(".widget-menu .widget-menu-size input").change(function () {
    $sizeSelected = $(".widget-menu-size input[name=widget_size]:checked").first();

    codeWidget = $(".widget-menu textarea[name=widget_size_code]").first().text();

    includeSelected = $(".widget-menu input[name=include_description]:checked").size();

    if (includeSelected) {
      codeWidget = codeWidget.replace('show_description=false', 'show_description=true');
    } else {
      codeWidget = codeWidget.replace('show_description=true', 'show_description=false');
    };
    if ($sizeSelected.val() == "small") {
      codeWidget = codeWidget.replace(/height:.+?;/, 'height:400px;');
      codeWidget = codeWidget.replace(/size=.+?&/, 'size=small&');
    };
    if ($sizeSelected.val() == "medium") {
      codeWidget = codeWidget.replace(/height:.+?;/, 'height:500px;');
      codeWidget = codeWidget.replace(/size=.+?&/, 'size=medium&');
    };
    if ($sizeSelected.val() == "tall") {
      codeWidget = codeWidget.replace(/height:.+?;/, 'height:600px;');
      codeWidget = codeWidget.replace(/size=.+?&/, 'size=tall&');
    };

    $("textarea[name=widget_size_code]").first().text(codeWidget);
  });

  $(".widget-menu .widget-menu-size input").first().trigger("change");


  /* Open the content media inside a voice if the url contain a hash
   *  ej: http://crowdvoice.org/voice1#content2
   * hash is #content2 and then overlay using prettyPhoto.
   * open pageslide for links http://localhost:3000/water-voices#6
   */
  if (window.location.hash) {
    var linkId = window.location.hash;
    linkId = linkId.substr(1);
    var $contentRefLink = $("a[name=" + linkId + "]");
    var $pageSlide = $contentRefLink.nextAll(".url").children("a.pageSlide");
    /* if is PrettyPhoto content (image/video) open it in overlay*/
    var $content = $contentRefLink.next("a[rel=prettyPhoto]");

    if ($content.size()) {
      image = $content.attr('href');
      title = ($content.find('img').attr('alt')) ? $content.find('img').attr('alt') : '';
      description = ($content.attr('title')) ? $content.attr('title') : '';
      $content.prettyPhoto();
      setTimeout(function () {
        $.prettyPhoto.open(image, title, description);
      }, 1000);
    } else {
      /* is page slide use pageslider */
      if ($pageSlide.size()) {
        $pageSlide.openPageSlide();
      };
    };

  };
});
