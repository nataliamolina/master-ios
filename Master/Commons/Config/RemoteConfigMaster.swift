import Foundation

public protocol RemoteConfigDelegate: class {
    func getRemoteConfig(module: String) -> String
}

public protocol RemoteConfigProtocol {
    func isAvaliable(module: String) -> String
}

public class RemoteConfigMaster: RemoteConfigProtocol {
    
    public static weak var delegate: RemoteConfigDelegate?
    
    public func isAvaliable(module: String) -> String {
        
        return RemoteConfigMaster.delegate?.getRemoteConfig(module: module) ?? ""
    }
}
