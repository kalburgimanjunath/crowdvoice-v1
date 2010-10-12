module ApplicationHelper
  def google_analytics
    code = <<-eos
    <script type="text/javascript">

      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-298928-15']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
    eos
    code.html_safe
  end

  def chartbeat
    code = <<-eos
      <script type="text/javascript">
      var _sf_startpt=(new Date()).getTime();
      $(function() {
        var _sf_async_config={uid:13467,domain:"crowdvoice.org"};
        (function(){
          function loadChartbeat() {
            window._sf_endpt=(new Date()).getTime();
            var e = document.createElement('script');
            e.setAttribute('language', 'javascript');
            e.setAttribute('type', 'text/javascript');
            e.setAttribute('src',
               (("https:" == document.location.protocol) ? "https://s3.amazonaws.com/" : "http://") +
               "static.chartbeat.com/js/chartbeat.js");
            document.body.appendChild(e);
          }
          var oldonload = window.onload;
          window.onload = (typeof window.onload != 'function') ?
             loadChartbeat : function() { oldonload(); loadChartbeat(); };
        })();
      });
      </script>
    eos
    code.html_safe
  end
  
  # Displays the enclosed block only if the current user is an admin
  def admin(&block)
    if logged_in? && current_user.admin?
      capture(&block)
    end
  end
  
  # Sets the content for the title section
  def title(page_title, show_title = true)
    content_for(:title) { page_title }
    @show_title = show_title
    page_title
  end
  
  # Returns true or false whether the main title in the layout
  # should be displayed
  def show_title?
    @show_title
  end
  
  # Links the passed stylesheets in the proper +head+ tag of the layout
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  # Includes the passed javascripts in the proper +head+ tag of the layout
  def javascript(*args)
    # Cannot convert to_s because we have custom javascript expansions
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  # Returns the StaticPage object with the specified pagetype
  def page_with_type(pagetype="about")
    page = StaticPage.where("page_type = '#{pagetype}'").first
  end
  
  # Return the path of the page object returned from the above method
  def static_page_path_with_type(pagetype="about")
    static_page_path(page_with_type(pagetype))
  end
end
