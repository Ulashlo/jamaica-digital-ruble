import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.gas.StaticGasProvider;

import java.math.BigInteger;

public class Main {
    private static String contractAddress = "0x4BE879dBDFeca9E3d3206AA06f8bdC97360ca858";
    private static String address = "0x3BDF6B821c2BBb7C2e405DfA21686672225E56f4";
    private static String key = "e773503ad9ce1d5505594f9e299291afd50dc7c62d00cc84f9de9a9cf41b77a9";

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
