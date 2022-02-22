import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.gas.StaticGasProvider;

import java.math.BigInteger;

public class Main {
    private static String contractAddress = "0xB2c363333EB46c865C1ebaDf7411c443Ac2E0d9F";
    private static String address = "0xB8e04865A2E385739508B430da58A6625514980a";
    private static String key = "f575ea7bdcad594780c35082fc39cddb0f1c97df06eade2208277c49beef74d6";

    public static void main(String[] args) throws Exception {
        Web3j web3j = Web3j.build(new HttpService("http://localhost:7545/"));
        JDR contract = JDR.load(
            contractAddress,
            web3j,
            Credentials.create(key),
            new StaticGasProvider(BigInteger.valueOf(20000000000L), BigInteger.valueOf(6721975L)));
        System.out.println(contract.mint(BigInteger.valueOf(1000)).send());
        System.out.println(contract.balances(address).send());
        System.out.println("done");
    }
}
