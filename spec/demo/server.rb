$LOAD_PATH.push File.expand_path('../../../lib', __FILE__)

require 'navtastic'
require 'erb'
require 'webrick'

class DemoServer
  def initialize(port)
    @port = port
  end

  def start
    s = WEBrick::HTTPServer.new Port: @port, DocumentRoot: 'demo/', RequestCallback: -> (req, res) do
      # A poor man's hot reload. Just reload everything on every request.
      Object.send(:remove_const, :Navtastic) if Object.constants.include?(:Navtastic)

      Dir.glob('lib/**/*.rb').sort_by(&:length).each do |file|
        load file
      end
    end

    # Add a mime type for *.rhtml files
    WEBrick::HTTPUtils::DefaultMimeTypes.store('rhtml', 'text/html')

    # Mount servlets
    s.mount '/', WEBrick::HTTPServlet::ERBHandler, File.expand_path('../index.rhtml', __FILE__)
    s.mount '/simple', RendererServlet, :simple
    s.mount '/bulma', RendererServlet, :bulma

    # Trap signals so as to shutdown cleanly.
    ['TERM', 'INT'].each do |signal|
      trap(signal) { s.shutdown }
    end

    # Start the server and block on input.
    s.start
  end
end

class RendererServlet < WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, renderer)
    @renderer = renderer
  end

  def do_GET(request, response)
    @request = request

    response.status = 200
    response['Content-Type'] = 'text/html'
    response.body = render_page
  end

  def render_page
    template_file = File.expand_path("../renderer/#{@renderer}.rhtml", __FILE__)
    template_string = File.read template_file

    ERB.new(template_string).result(binding)
  end

  def current_url
    @request.path
  end
end
