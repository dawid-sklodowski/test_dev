1#Use this class to make your custom performance tests on choosen environment (development by default)
#
#Example of testing class
#
#class EventTest < TestDev
#  before :all do
#    #Do Something
#  end
#
#  before :each do
#    #Do Something
#  end
#
#  after :all do
#    #Do Something
#  end
#
#  after :each do
#    #Do Something
#  end
#
#  test 'how fast it can go' do
#    #do something
#  end
#end

class TestDev

  LOG = true

  @children = []
  @@logger_string = ''
  @@logger = StringIO.new(@@logger_string,'w+')
  ActiveRecord::Base.logger = Logger.new(@@logger)
  @@connected_to = nil
  @@before = {}
  @@after = {}
  @@tests = []


  def self.inherited(subclass)
    @children << subclass
  end


  def self.before(what, &block)
    @@before[what] ||= {}
    @@before[what][self.to_s] = block
  end


  def self.after(what, &block)
    @@before[what] ||= {}
    @@before[what][self] = block
  end


  def self.test(description, &block)
    @@tests << [description, block]
  end


  private
  def self.run_filters(filters, what, test_class)
    if filters[what] && filters[what][test_class.to_s]
      filters[what][test_class.to_s].call
    end
  end


  def self.logger(test_class)
    puts "Queries: #{'-' * 110}"
    puts @@logger_string if test_class::LOG
    @@logger_string.gsub!(/.*/m, '')
    puts "\n #{'-' * 120} \n"
  end



  at_exit do
    @children.each do |test_class|
      if !@connected_to || ENV["RAILS_ENV"] != @connected_to
        ActiveRecord::Base.establish_connection(ENV["RAILS_ENV"])
      end
      run_filters(@@before, :all, test_class)
      @@tests.each do |description, block|
        run_filters(@@before, :each, test_class)
        puts "Testing #{description}"
        Benchmark.bm do |x|
          x.report('First Run') {block.call}
          logger(test_class)
          x.report('Second Run') {block.call}
          logger(test_class)
        end
        run_filters(@@after, :each, test_class)
      end
      run_filters(@@after, :all, test_class)
    end
  end
end