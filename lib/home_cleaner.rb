require "fileutils"
require "optparse"
require "yaml"

class HomeCleaner
  VERSION = "10.8.27"
  
  def self.default_options
    {
      :base   => "/Users",
      :force  => nil,
      :config => "#{File.dirname(File.expand_path(__FILE__))}/../config/home_cleaner.yml"
    }
  end
  
  def self.parse_options
    options = self.default_options
    
    opts = OptionParser.new do |opts|
      opts.on("--test", "Testmode sets base directory to HOME_CLEANER-DIR/tmp and configuration file to HOME_CLEANER-DIR/config/test.conf") do 
        options[:base] = "#{base}/tmp"
        options[:config]  = "#{base}/config/test.conf"
      end
      opts.on("--version", "Version") do |v|
        puts "home_cleaner version: #{VERSION}"
        exit(1)
      end
      opts.on("--force", "Delete all user directories that are not blacklisted or currently logged in.") do |f|
        options[:force] = f
      end
      opts.on("--config <file>", "Path to a configfile that should be used instead of the default HOME_CLEANER-DIR/config/home_cleaner.yml") do |f|
        options[:config] = f
      end
      if options[:help]
        p opts.banner
      end
    end
    begin
      opts.parse!(ARGV)
    rescue OptionParser::InvalidOption => e
      puts e
      puts opts
      exit 1
    end
    
    options
  end
  
  def initialize(options)
    @base_dir = options[:base]
    @home_users = nil
    @local_users = nil
    @force = options[:force]
    usage unless File.file?(options[:config])
    config = YAML.load(File.read(options[:config]))
    @threshold = config["threshold"]
    @blacklist = config["blacklist"]
  end
  
  def usage
    $stderr.puts "Try running with '-h' to get a help message"
    exit(1)
  end

  def blacklisted?(dirname)
    @blacklist.member?(dirname)
  end
  
  def too_young?(dirname)
    if File.exists?(dirname)
      seconds = Time.now - File.stat(dirname).mtime 
      seconds < @threshold
    end 
  end
  
  def clean(username)
    puts "clean(#{username})"
    return nil unless username
    return nil if logged_in?(username)
    return nil if local_user?(username)
    
    dir = "#{@base_dir}/#{username}"
    return nil unless dir
    return nil unless File.directory?(dir) 
    return nil if blacklisted?(dir)
    
    unless @force
      # This is a bit hackish!
      # modification on each login/logout
      if too_young?("#{dir}/Library/Preferences") 
        return nil 
      end
    end
    puts "remove #{dir}"
    FileUtils.rm_rf(dir)
    
    username
  end
  
  # use simple caching scheme
  def home_users
    @home_users ||= Dir.entries(@base_dir).select {|name| ! name.match(/^\./)}
  end
  
  # use simple caching scheme
  def local_users
    @local_users ||= `dscl . list /users`.split
  end
  
  def local_user?(username)
    local_users.member?(username)
  end

  # Shell out using users(1)
  def logged_in?(username)
    `users`.split.member?(username)
  end
  
  def run
    begin
      home_users.each do |huser|
        clean(huser)
      end
      0
    rescue Exception => e
      $stderr.puts e
      $stderr.puts e.backtrace
      -1
    end
  end
end