require 'spec_helper'

describe PageParser do

  before(:all) do
    @page = PageParser.parse('http://freshout.us')
  end

  should 'retrieve title' do
    @page.title.should == 'Web Application Design & Development Agency | San Francisco'
  end

  should 'retrieve first image' do
    @page.first_image.should == 'http://freshout.us/wp-content/themes/freshout/images/logo.png'
  end

end

describe 'PageParser default values' do

  before(:all) do
    @url = 'http://google.com'
    @page = PageParser.parse(@url, '<html><head></head><body></body></html>')
  end

  should 'not fail if page does not have a title' do
    @page.title.should == PageParser::DEFAULT_TITLE
  end

  should 'not fail if page does not have a description' do
    @page.description.should == PageParser::DEFAULT_BODY
  end

  should 'return default image if there no images in doc' do
    @page.images.should == [PageParser::DEFAULT_IMAGE]
  end

  should 'return default body if no body is given!' do
    @page = PageParser.parse(@url, '<html></html>')
    @page.description.should == PageParser::DEFAULT_BODY
  end

  should 'return default title if no title is given!' do
    @page = PageParser.parse(@url, '<html></html>')
    @page.title.should == PageParser::DEFAULT_TITLE
  end

end

describe 'PageParser content fetching' do

  before(:all) do
    @url = 'http://google.com'
  end

  should 'grab a description from the body tag' do
    data = '<html><head></head><article>abc</article></html>'
    @page = PageParser.parse(@url, data)
    @page.description.should == 'abc'
  end

  should 'grab a description from the article tag' do
    data = '<html><head></head><body>abc<article>def</article></body></html>'
    @page = PageParser.parse(@url, data)
    @page.description.should == 'def'
  end

  should 'grab a description from a #content tagged tag' do
    data = '<html><head></head><body>abc<div id="content">ghi</div></body></html>'
    @page = PageParser.parse(@url, data)
    @page.description.should == 'ghi'
  end

  should 'grab a description from meta tag' do
    data = '<html><head><meta name="description" content="test" /></head>' +
    '<body>abc<div id="content">ghi</div></body></html>'
    @page = PageParser.parse(@url, data)
    @page.description.should == 'test'
  end

end

describe 'PageParser dynamic path expansion' do

  before(:all) do
    @url = 'http://example.com'
    data = '<html><head></head><body><img src="/something.jpg"></body></html>'
    @page = PageParser.parse(@url, data)
  end

  should 'expand paths for images' do
    @page.images.size.should == 1
    @page.images.should == ['http://example.com/something.jpg']
  end

  should 'target first image acurately!' do
    @page.first_image.should == 'http://example.com/something.jpg'
  end

  should 'target first image acurately2!' do
    @url = 'http://example.com'
    data = '<html><head></head><body><img src="/one.jpg"><img src="/two.jpg"></body></html>'
    @page = PageParser.parse(@url, data)
    @page.first_image.should == 'http://example.com/one.jpg'
  end

end


describe 'PageParser should not fetch javascript or css' do

  before :all do
    @url = 'http://example.com'
  end

  def google_code
    File.read('spec/fixtures/google_page.html')
  end

  def only_js_code
    '<html><head></head><body><script> this is javascript </script</body></html>'
  end

  def only_css_code
    '<html><head></head><body><style> this is css code </style></body></html>'
  end

  should 'not read javascript or css as content (google)' do
    @page = PageParser.parse(@url, google_code)
    @page.description.should == '© 2010 - Privacy'
  end

  should 'not read javascript or css as content' do
    @page = PageParser.parse(@url, only_css_code)
    @page.description.should == PageParser::DEFAULT_BODY
  end

end
