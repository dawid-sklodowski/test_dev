require File.dirname(__FILE__) + '/../test_dev_helper'

class TestingSelf < TestDev


  before :all do
    puts 'Start testing'
  end

  before :each do
    @test_num ||=0
    @test_num += 1
    puts "\n\n\nRunning test number #{@test_num}"
  end

  after :all do
    #Do Something
  end

  after :each do
    #Do Something
  end

  test 'doing some time expensive operation' do
    #You can use Active Record here.
    #User.all.first.albums.collect
    sleep 1
  end


end