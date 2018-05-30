Pod::Spec.new do |s|
  s.name             = 'GlassNavigationBar'
  s.version          = '0.1.0'
  s.summary          = 'Adjust your NavigationBar Transparency, while scrolling'

  s.description      = <<-DESC
                        1. Adjust your NavigationBar's Transparency, while scrolling
                        2. Allow to put your ScrollView above status bar
                       DESC

  s.homepage         = 'https://github.com/hcn1519/GlassNavigationBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Changnam Hong' => 'hcn1519@gmail.com' }
  s.source           = { :git => 'https://github.com/hcn1519/GlassNavigationBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'GlassNavigationBar/GlassNavigationController.swift'
  s.frameworks = 'UIKit'
end
