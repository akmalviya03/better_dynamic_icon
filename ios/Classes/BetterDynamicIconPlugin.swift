import Flutter
import UIKit

public class IconsInitializer {
    public static var icons: [String] = []
}

public class BetterDynamicIconPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "better_dynamic_icon", binaryMessenger: registrar.messenger())
        let instance = BetterDynamicIconPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "getAllIcons":
            getAllIcons(result: result)
        case "changeAppIcon":
            if let args = call.arguments as? [String: Any],
                let iconName = args["iconName"] as? String
            {
                if getPrimaryAppIconName()?.contains(iconName) ?? false {
                    self.changeAppIcon(to: nil, result: result)
                } else {
                    self.changeAppIcon(to: iconName, result: result)
                }
                result("Done")
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGS", message: "Invalid arguments",
                        details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func changeAppIcon(
        to iconName: String?, result: @escaping FlutterResult
    ) {
        guard UIApplication.shared.supportsAlternateIcons else {
            result(
                FlutterError(
                    code: "NOT_SUPPORTED",
                    message: "Alternate icons not supported", details: nil))
            return
        }
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                result(
                    FlutterError(
                        code: "ICON_CHANGE_FAILED",
                        message: error.localizedDescription, details: nil))
            } else {
                result(nil)
            }
        }
    }

    private func getAllIcons(result: @escaping FlutterResult) {
        var icons: [[String: Any?]] = []

        // Usage
        if let iconName = getPrimaryAppIconName() {
            print("Primary app icon name: \(iconName)")
        } else {
            print("Failed to retrieve primary app icon name.")
        }

        if let primaryIcon = getPrimaryAppIconName() {
            IconsInitializer.icons.forEach { value in
                let iconName = "App-\(value)"
                icons.append([
                    "name": iconName,
                    "label": value,
                    "enabled": checkIconEnableOrNot(
                        iconName: iconName, primaryIcon: primaryIcon),
                    "icon": FlutterStandardTypedData(
                        bytes: UIImage(named: value)?.pngData() ?? Data()),
                ])
            }
        }
        result(icons)
    }

    func checkIconEnableOrNot(iconName: String, primaryIcon: String) -> Bool {
        if getPrimaryAppIconName()?.contains(iconName) ?? false {
            return UIApplication.shared.alternateIconName == nil
        } else {
            return UIApplication.shared.alternateIconName == iconName
        }
    }

    func getPrimaryAppIconName() -> String? {
        guard let infoPlist = Bundle.main.infoDictionary else {
            return nil
        }
        // Navigate to the CFBundleIcons key
        if let icons = infoPlist["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String]
        {
            // Return the first icon name (usually the primary icon)
            return iconFiles.first
        }
        return nil
    }
}
