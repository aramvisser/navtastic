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

      Dir.glob('lib/**/*.rb').each do |file|
        load file
      end
    end

    # Add a mime type for *.rhtml files
    WEBrick::HTTPUtils::DefaultMimeTypes.store('rhtml', 'text/html')

    # Mount servlets
    #s.mount('/', HTTPServlet::FileHandler, Dir.pwd)
    s.mount '/', MenuServlet

    # Trap signals so as to shutdown cleanly.
    ['TERM', 'INT'].each do |signal|
      trap(signal){ s.shutdown }
    end

    # Start the server and block on input.
    s.start
  end
end

class MenuServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    response.status = 200
    response['Content-Type'] = 'text/html'
    response.body = render_page request
  end

  def render_page(request)
    template_file = File.expand_path('../index.rhtml', __FILE__)
    template_string = File.read template_file

    current_url = request.path

    ERB.new(template_string).result(binding)
  end
end
