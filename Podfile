# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def import_pods
    pod 'IGListKit'
end

target 'IGListNetworkSample' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for IGListNetworkSample
  #platform :osx, '10.7'
  import_pods

  target 'IGListNetworkSampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IGListNetworkSampleUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


# [!] The platform of the target `IGListNetworkSample` (OS X 10.8) is not compatible with `IGListKit (2.0.0)`, which does
# not support `osx`.
# IGListKit-macOS : there is no macOS target under cartfile installation...
