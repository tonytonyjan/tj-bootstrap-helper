module TJBootstrapHelper
  module Helper
    def record_message object
      error_messages_for object, :class=>"alert alert-block alert-error", :header_tag=>"h4"
    end

    def notice_message
      flash_messages = []
      flash.each do |type, message|
        type = case type
        when :notice then :success
        when :alert then :error
        end
        content = content_tag :div, :class => "alert fade in alert-#{type}" do
          button_tag("x", :class => "close", "data-dismiss" => "alert") + message
        end
        flash_messages << content if message.present?
      end
      flash_messages.join("\n").html_safe
    end

    # title, size = 1
    #
    # size = 1, &block
    def page_header *args, &block
      if block_given?
        size = (1..6) === args.first ? args.first : 1
        content_tag :div, :class => "page-header" do
          content_tag "h#{size}" do
            capture(&block)
          end
        end
      else
        title = args.first
        size = (1..6) === args.second ? args.second : 1
        content_tag :div, content_tag("h#{size}", title), :class => "page-header"
      end
    end

    # Just like +link_to+, but wrap with li tag and set +class="active"+
    # to corresponding page.
    def nav_li *args, &block
      options = (block_given? ? args.first : args.second) || {}
      url = url_for(options)
      active = "active" if url == request.path || url == request.url
      content_tag :li, :class => active do
        link_to *args, &block
      end
    end

    # Options
    # span:: integer between 1..12. Item size.
    # slice:: integer between 1..12. Items per slice (row).
    # fluid:: boolean. Whether the div tag is fluid.
    def spans resources, options = {}, &block
      return unless resources.is_a?(Array) || resources.is_a?(ActiveRecord::Relation)
      options[:span] ||= 4
      options[:slice] ||= 12/options[:span]
      options[:fluid] ||= false
      klass = options[:fluid] ? "row-fluid" : "row"
      ret = "".html_safe

      resources.each_slice(options[:slice]) do |slice|
        ret += content_tag :div, :class=>klass do
          slice.inject("".html_safe) do |sum, resource|
            send_args = resource.is_a?(ActiveRecord::Base) ? [:content_tag_for, :div, resource] : [:content_tag, :div]
            send_args << {:class => "span#{options[:span]}"}
            sum + send(*send_args) do
              capture(resource, &block)
            end
          end
        end
      end
      ret
    end

    # Options
    # span:: integer between 1..12. Item size.
    # slice:: integer between 1..12. Items per slice.
    # url_method:: string or symbol. URL method of items, default is resources' RESTful URL.
    def thumbs resources, image_url_method, options = {}, &block
      return unless resources.is_a?(Array) || resources.is_a?(ActiveRecord::Relation)
      options[:span] ||= 4
      options[:slice] ||= 12/options[:span]
      ret = "".html_safe

      resources.each_slice(options[:slice]) do |slice|
        ret += content_tag :ul, :class => "thumbnails" do
          slice.inject("".html_safe) do |sum, resource|
            img_url = resource.send(image_url_method)
            url = options[:url_method] ? resource.send(options[:url_method]) : url_for(resource)
            send_args = resource.is_a?(ActiveRecord::Base) ? [:content_tag_for, :li, resource] : [:content_tag, :li]
            send_args << {:class => "span#{options[:span]}"}
            sum + send(*send_args) do
              if block_given?
                content_tag :div, :class => "thumbnail" do
                  image_tag(img_url) + capture(resource, &block)
                end
              else
                link_to image_tag(img_url), url, :class => "thumbnail"
              end
            end
          end
        end
      end
      ret
    end
  end
end
ActionView::Base.send :include, TJBootstrapHelper::Helper