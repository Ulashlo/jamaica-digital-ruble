const JDR = artifacts.require("JDR");

contract('JDR', (accounts) => {
    let jdr;
    let owner = accounts[0];

    beforeEach('Setup JDR', async () => {
        jdr = await JDR.deployed();
    })

    describe('#owner', () => {
        it('Should have correct owner', async () => {
            const expected_owner = await jdr.owner.call();

            assert.equal(expected_owner, owner, "Wrong owner");
        });
    })

    describe('#mint', () => {
        it('Should mint new jdr successfully', async () => {
            await jdr.mint.call(1500);

            const minted = await jdr.balances.call(owner);
            console.log(minted.amount)
            assert.equal(1500, minted.amount, "Wrong amount of minted jdr");
        });
    })

    describe('#transfer', () => {
        before('Mint JDR', async () => {
            await jdr.mint.call(3000);
        })

        it('Should transfer jdr successfully', async () => {
            await jdr.transfer.call(accounts[1], 1000);

            const transfered = await jdr.balances.call(accounts[1]);
            assert.equal(950, transfered.amount, "Wrong amount of transfered jdr");
        });
    })
});
