Pod::Spec.new do |s|
  s.name = "DKPictureGallery"
  s.version = "0.0.2"
  s.summary = "iOS library, that shows picture's in default iOS picture gallery."
  s.homepage = "https://github.com/wade0n/DKPictureGallery"
  s.license = { :type => 'MIT', :file => 'LICENSE'}
  s.author = { "Dmitrii Kalashnikov" => "mr.dmitriikalashnikov@gmail.com" }
  s.source = {
      :git => "https://github.com/wade0n/DKPictureGallery.git",
      :tag => s.version.to_s
    }

  s.ios.deployment_target = '7.0'

  s.default_subspec = 'core'

  s.subspec 'core' do |c|
    c.requires_arc = true
    c.source_files = 'core/Source/*','core/Source/Models/*','core/Source/Extensions/*'
    c.resources = 'core/Resources/*'
    c.dependency  'iOS-blur', '0.0.2'
    c.dependency  'SDWebImage'
  end

  s.subspec 'demo' do |d|
    d.requires_arc = true
    d.source_files = 'demo/source/*'
    d.resources = 'demo/resources/*'
    d.preserve_paths = "PictureGallery.xcodeproj", "Podfile"
    d.dependency 'DKPictureGallery/core'
  end

end

