#
# Be sure to run `pod lib lint RippleEffectView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RippleEffectView'
  s.version          = '1.0.0'
  s.summary          = 'A short description of RippleEffectView.'

  s.description      = <<-DESC
                        RippleEffectView simulates ripples with a custom view. It's a cool effect!
                       DESC

  s.homepage         = 'https://github.com/alsedi/RippleEffectView'
  s.screenshots     = 'https://github.com/alsedi/RippleEffectView/blob/master/rippleEffectView1.gif', 'https://github.com/alsedi/RippleEffectView/blob/master/rippleEffectView2.gif', 'https://github.com/alsedi/RippleEffectView/blob/master/rippleEffectView3.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Alex Sergev' => 'mbalex99@gmail.com' }
  s.source           = { :git => 'https://github.com/alsedi/RippleEffectView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RippleEffectView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RippleEffectView' => ['RippleEffectView/Assets/*.png']
  # }
   s.frameworks = 'UIKit'
end
