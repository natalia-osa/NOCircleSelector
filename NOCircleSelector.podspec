Pod::Spec.new do |spec|
  spec.name         = "NOCircleSelector"
  spec.version      = "0.2"
  spec.summary      = "Circle shaped control to select given number of values."
  spec.homepage     = "http://macrix.com/"
  spec.license      = 'Apache 2.0'
  spec.author       = { "natalia.osiecka" => "osiecka.n@gmail.com" }
  spec.source       = { :git => 'https://github.com/natalia-osa/NOCircleSelector.git', :tag => '0.2'}

  spec.requires_arc = true
  spec.ios.deployment_target = '5.0'
  spec.source_files = 'NOCircleSelector/*.{h,m}'

  spec.frameworks   = ['Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore']
end
