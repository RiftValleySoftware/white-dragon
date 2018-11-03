use_frameworks!

workspace 'WhiteDragon.xcworkspace'
project 'WhiteDragon.xcodeproj'
project 'WhiteDragonTestHarness.xcodeproj'

target 'WhiteDragon(iOS)' do
    platform:ios, '11.0'
    project 'WhiteDragon.xcodeproj'
    pod 'SwiftLint', '~> 0.24'
end

target 'WhiteDragon(OSX)' do
    platform:macos, '10.11'
    project 'WhiteDragon.xcodeproj'
    pod 'SwiftLint', '~> 0.24'
end

target 'WhiteDragonTestHarness(iOS)' do
    platform:ios, '11.0'
    project 'WhiteDragonTestHarness.xcodeproj'
    pod 'SwiftLint', '~> 0.24'
    pod 'Reveal-SDK', :configurations => ['Debug']
end
