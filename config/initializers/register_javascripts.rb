ActionView::Helpers::AssetTagHelper.register_javascript_expansion :voice => [
  'Neon',
  'Widget',
  'Crowdvoice',
  'Crowdvoice/AjaxSearch',
  'Crowdvoice/Carousel',
  'Crowdvoice/Helpers',
  'Crowdvoice/Helpers/UrlHelper',
  'Crowdvoice/Voice',
  'Crowdvoice/Voice/Content',
  'Crowdvoice/Voice/Twitter',
  'Crowdvoice/Voice/Twitter/Tweet',
  'Crowdvoice/Voice/Twitter/Retweet',
  'Crowdvoice/Voice/Twitter/Row',
  'Crowdvoice/Voice/Twitter/Controls',
  'Crowdvoice/Voice/Twitter/Search',
  'Crowdvoice/Voice/Twitter/Divider',
  'jquery.masonry.min',
  'Crowdvoice/Voice/application'
]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :ajaxsearch => [
  'Neon',
  'Widget',
  'Crowdvoice',
  'Crowdvoice/AjaxSearch',
  'Crowdvoice/Carousel',
  'Crowdvoice/Voice',
  'jquery.masonry.min',
  'Crowdvoice/Voice/application'
]

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jquery => [
  'jquery',
  'jquery-ui',
  'jquery.rails',
  'application'
]
