//
//  FeatureConfigParser.swift
//  ve_sdk_flutter
//
//  Created by German Khodyrev on 6.08.24.
//

import Foundation

extension VeSdkFlutterPlugin {
    func parseFeatureConfig(_ featuresConfigString: String?) -> FeaturesConfig {
        guard let featuresConfigData = featuresConfigString?.data(using: .utf8) else {return emptyFeaturesConfig}
        do {
            let decodedFeatureConfig = try JSONDecoder().decode(FeaturesConfig.self, from: featuresConfigData)
            return decodedFeatureConfig
        } catch {
            print(VeSdkFlutterPlugin.errMessageMissingConfigParams)
            return emptyFeaturesConfig
        }
    }
}
