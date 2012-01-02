class TestDevGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.file 'test_dev_helper.rb', 'test/test_dev_helper.rb'
      m.directory 'test/test_dev'
      m.file 'example_test.rb', 'test/test_dev/example_test.rb'
    end
  end
end
