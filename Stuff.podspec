Pod::Spec.new do |s|
  s.name         = "Stuff"
  s.version      = "1.1.0"
  s.summary      = "Too small for a library, too important to just forget"

  s.description  = <<-EOS
This is a collection of helpfull code that is difficult to place in a specific library.
EOS

  s.homepage     = "https://github.com/evermeer/Stuff"
  s.license      = { :type => "MIT", :file => "License" }
  s.author             = { "Edwin Vermeer" => "edwin@evict.nl" }
  s.social_media_url   = "http://twitter.com/evermeer"

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/evermeer/Stuff.git", :tag => s.version }
  s.default_subspec = "All"

# This is the complete Stuff library
  s.subspec "All" do |ss|
    ss.dependency "Stuff/Enum"
    ss.dependency "Stuff/Print"
    ss.dependency "Stuff/TODO"
    ss.dependency "Stuff/Codable"
  end

# This is the core Print library
  s.subspec "Print" do |ss|
    ss.source_files  = "Source/*.swift", "Source/Print/*.swift"
  end

# This is the core Enum library
  s.subspec "Enum" do |ss|
    ss.source_files  = "Source/*.swift", "Source/Enum/*.swift"
  end

# This is the core TODO library
  s.subspec "TODO" do |ss|
    ss.source_files  = "Source/TODO/*.swift"
  end

# This is the core Coding library
  s.subspec "Codable" do |ss|
    ss.source_files  = "Source/Codable/*.swift"
  end
end
