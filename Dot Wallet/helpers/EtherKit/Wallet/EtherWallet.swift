import web3swift
import BigInt
import Cache
public class EtherWallet {
    
    public static let shared = EtherWallet()
    public static let account: AccountService = EtherWallet.shared
    public static let balance: BalanceService = EtherWallet.shared
    public static let transaction: TransactionService = EtherWallet.shared
    public static let tokens: TokenService = EtherWallet.shared
    public static let gas: GasService = EtherWallet.shared
    
    public var web3Main = Web3.InfuraRinkebyWeb3() // Change to MainNet when Launch
    public var etherscanURL = "https://api-rinkeby.etherscan.io" // Change to MainNet when Launch
    let tokenImageSrcURL = "https://raw.githubusercontent.com/trustwallet/tokens/master/images/"
    let keystoreDirectoryName = "/keystore"
    let keystoreFileName = "/key.json"
    let defaultGasLimitForTokenTransfer = 100000
    let defaultGasLimitForCollectibleTransfer = 500000
    
    var options: Web3Options
    var keystoreCache: EthereumKeystoreV3?
    
    public let imageStorage = try? Storage(
        diskConfig: DiskConfig(name: "Tokens"),
        memoryConfig: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10),
        transformer: TransformerFactory.forImage()
    )
    var storage:Storage<UIImage>
    
    private init() {
        options = Web3Options.defaultOptions()
        options.gasLimit = BigUInt(defaultGasLimitForTokenTransfer)
        storage = (imageStorage?.transformImage())!
        setupOptionsFrom()
    }
    
    func setupOptionsFrom() {
        if let address = address {
            options.from = EthereumAddress(address)
        } else {
            options.from = nil
        }
    }
    
   
}
