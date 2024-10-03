import Foundation

extension VeSdkFlutterPlugin {
    func parseExportParams(_ rawConfigParams: String?) -> ExportParam {
        guard let exportParamsData = rawConfigParams?.data(using: .utf8) else {return defaultExportParams}
        do {
            let decodedExportParams = try JSONDecoder().decode(ExportParam.self, from: exportParamsData)
            return decodedExportParams
        } catch {
            print(VeSdkFlutterPlugin.errMessageMissingExportParam)
            return defaultExportParams
        }
    }
}
