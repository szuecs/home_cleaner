base = "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}"
$:.unshift(base)

require 'test/unit'
require 'lib/home_cleaner'

class TestHomeCleaner < Test::Unit::TestCase
  BASEDIR = "tmp"
  
  def setup
    @net_users = ["testuser1","testuser2","testuser3"]
    @logged_in =  `users`.split
    @local_users = `dscl . list /users`.split.shuffle.take(5)
    @test_user =   @net_users | @logged_in |  @local_users
    
    @test_user.each do |username|
      STDERR.puts "create #{BASEDIR}/#{username}"
      FileUtils.mkdir("#{BASEDIR}/#{username}")
    end
  end
  def teardown
    if BASEDIR == "tmp"
      STDERR.puts "remove #{BASEDIR}/"
      FileUtils.rm_rf("#{BASEDIR}") 
      FileUtils.mkdir("#{BASEDIR}")
    end
  end
  
  def hc_new
    HomeCleaner.new({:base => BASEDIR, :config => "#{File.dirname(File.expand_path(__FILE__))}/../config/test.yml"})
  end
  
  def test_local_user?
    hc = hc_new
    assert_equal true, hc.local_user?("root")
    assert_equal true, hc.local_user?(@local_users.first)
    assert_equal false, hc.local_user?(@net_users.first)
  end
  
  def test_logged_in?
    hc = hc_new
    testuser = `users`.split.first
    assert_equal true, hc.logged_in?(testuser)
  end
  
  def test_clean
    hc = hc_new
    
    assert_equal nil, hc.clean("user_does_not_exist")
    assert_equal nil, hc.clean(@logged_in.first)
    assert_equal true, File.directory?("#{BASEDIR}/#{@logged_in.first}")
    assert_equal nil, hc.clean(@local_users.first)
    assert_equal true, File.directory?("#{BASEDIR}/#{@local_users.first}")
    assert_equal @net_users.first, hc.clean(@net_users.first)
    assert_equal false, File.directory?("#{BASEDIR}/#{@net_users.first}")
  end
  
end