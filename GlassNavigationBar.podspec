Pod::Spec.new do |s|
  s.name             = 'GlassNavigationBar'
  s.version          = '0.2.0'
  s.summary          = 'Glassy UINavigationBar with Transparency Control and Color Conversion'
Camel
  s.description      = <<-DESC
                        1. Make yoru NavigationBar Transparent easily
                        2. Adjust your NavigationBar's Transparency, while scrolling
                        3. Put your ScrollView above status bar
                        4. Support Gradient Style color conversion of your navigationBar
                       DESC

  s.homepage         = 'https://github.com/hcn1519/GlassNavigationBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Changnam Hong' => 'hcn1519@gmail.com' }
  s.source           = { :git => 'https://github.com/hcn1519/GlassNavigationBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'GlassNavigationBar/GlassNavigationBar/*'
  s.frameworks = 'UIKit'
end
