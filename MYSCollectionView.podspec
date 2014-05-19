Pod::Spec.new do |s|
  s.name             = "MYSCollectionView"
  s.version          = "0.1.0"
  s.summary          = "A collection view that fixing some issues with inserting/deleting items in a collection view layout that uses UIKit Dynamics."
  s.homepage         = "https://github.com/mysterioustrousers/MYSCollectionView"
  s.license          = 'MIT'
  s.author           = { "Adam Kirk" => "atomkirk@gmail.com" }
  s.source           = { :git => "https://github.com/mysterioustrousers/MYSCollectionView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/atomkirk'
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'Classes/**/*.{h,m}'
end
