Pod::Spec.new do |spec|
  spec.name         = "NOCircleSelector"
  spec.version      = "1.0.1"
  spec.summary      = "Circle shaped control to select given number of values."
  spec.homepage     = "https://github.com/natalia-osa/"
  spec.license      = 'Apache 2.0'
  spec.author       = { "natalia.osiecka" => "osiecka.n@gmail.com" }
  spec.source       = { :git => 'https://github.com/natalia-osa/NOCircleSelector.git', :tag => '1.0.1'}

  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'
  spec.source_files = 'NOCircleSelector/*.{h,m}'

  spec.frameworks   = ['Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore']

  spec.subspec 'Core' do |ss|
    ss.dependency 'NOCategories'
  end
end
