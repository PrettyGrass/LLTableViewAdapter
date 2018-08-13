Pod::Spec.new do |s|
  s.name         = "LTableViewAdapter"
  s.version      = "1.1.1"
  s.summary      = "这是一个 UITableView 的适配器"
  s.homepage     = "http://ylin.club"
  s.license      = "MIT"
  s.author       = { "ylin8890" => "ylin8890@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  
  s.source       = { :git => "git@g.dou-pai.com:ios_component/LLTableViewAdapter.git", :branch => "1.1.1" }
  s.requires_arc = true

  s.public_header_files = 'LTableViewAdapter/**/*.{h}'
  s.resources    = "LTableViewAdapter/**/*.{png,xib,nib,bundle}"
  s.source_files = "LTableViewAdapter/**/*.{h,m}"
  
  s.dependency  'Masonry'

end
