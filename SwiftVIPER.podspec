Pod::Spec.new do |s|
  s.name             = 'SwiftVIPER'
  s.version          = '1.0.0'
  s.summary          = 'SwiftVIPER implementation is swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yunarta/SwiftVIPER'
  s.license          = { :type => 'GPL', :file => 'LICENSE' }
  s.author           = { 'Yunarta Kartawahyudi' => 'yunarta.kartawahyudi@gmail.com' }
  s.source           = { :git => 'https://github.com/yunarta/SwiftVIPER.git', :tag => s.version.to_s }

  s.default_subspec = 'Root'

  s.subspec 'Root' do |sp|
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = '10.10'

    sp.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    sp.source_files = 'SwiftVIPER/Classes/**/*'
  end

s.subspec 'Field' do |sp|
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = '10.10'
    
    sp.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    sp.source_files = 'Contribs/Field/**/*'
end

  s.subspec 'UIKit' do |sp|
    sp.ios.deployment_target = '8.0'

    sp.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    sp.source_files = 'Contribs/UIKit/Classes/**/*'

    sp.dependency 'SwiftVIPER/Root'
  end

  s.subspec 'UIKitTable' do |sp|
    sp.ios.deployment_target = '8.0'

    sp.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    sp.source_files = 'Contribs/VIPERTableData/Classes/**/*'

    sp.dependency 'SwiftVIPER/UIKit'
  end
end
