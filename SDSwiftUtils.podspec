Pod::Spec.new do |spec|
  spec.name             = 'SDSwiftUtils'
  spec.version          = '0.1.2'
  spec.summary          = 'Lightweight, dependency-free utilities for Swift.'
  spec.description      = <<-DESC
    SDSwiftUtils provides small, reusable helpers for common Swift tasks while
    keeping the API focused and dependency-free.
  DESC
  spec.homepage         = 'https://github.com/gd-liusida/swift-utils'
  spec.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  spec.author           = { 'Ada' => 'yklsdq@163.com' }
  spec.source           = { :git => 'https://github.com/gd-liusida/swift-utils.git', :tag => spec.version.to_s }
  spec.module_name      = 'SDSwiftUtils'
  spec.ios.deployment_target = '13.0'
  spec.swift_version    = '5.0'
  spec.source_files     = 'Sources/SDSwiftUtils/**/*.swift'
  spec.framework        = 'Foundation'
end
