const ERC20 = artifacts.require("ERC20PresetFixedSupply");
const DvTicketsOrder = artifacts.require("DvTicketsOrder");
const DvTicketsOrderFactory = artifacts.require("DvTicketsOrderFactory");

class Helper {

    static async setupAccountFunds(accounts, erc20Token, amount) {
        const account = accounts[0];

        // Make transaction from first account to second.
        for (let i = 2; i < 10; i++) {
            await erc20Token.transfer(accounts[i], amount, { from: account });
        }

        // Get balances of first and second account after the transactions.
        const accountOneEndingBalance = (await erc20Token.balanceOf.call(account)).toNumber();

        // send back
        assert.equal(accountOneEndingBalance, 680000000000, "Failed to transfer funds");
    }

    static async createTangible(factory, tokenAddress, name, short, value, tax, totalSupply, sender){
        const exampleOneContract = await factory.issue(tokenAddress, name, short, { value: 100000000 });

        const modelOneInstance = await DvTicketsOrder.at(exampleOneContract.logs[0].args[1]);
        const symbol = await modelOneInstance.symbol.call();

        assert.equal(symbol, "EXP", "Failed to issue Example Contract");

        // check if variables set
        const _name = await modelOneInstance.name.call();
        assert(_name, "Example", "Invalid name on TST");

        if(totalSupply == 0)
            totalSupply = 100;

        await modelOneInstance.initialize(tax, totalSupply, { from: sender });

        return modelOneInstance;
    }

    static async createTangiblePresale(factory, tokenAddress, name, short, value, tax, totalSupply, price, sender){
        const exampleOneContract = await factory.issue(tokenAddress, name, short, { value: 100000000 });

        const modelOneInstance = await DvTicketsOrder.at(exampleOneContract.logs[0].args[1]);
        const symbol = await modelOneInstance.symbol.call();

        assert.equal(symbol, "% EXP", "Failed to issue Example Contract");

        // check if variables set
        const _name = await modelOneInstance.name.call();
        assert(_name, "Example", "Invalid name on TST");

        const start = new Date();
        start.setHours(start.getHours() - 10);
        const end = new Date(start);
        end.setHours(start.getHours() + 20);
        await modelOneInstance.initializePresale(tax, totalSupply, price, parseInt(start.getTime() / 1000), parseInt(end.getTime() / 1000), { from: sender });

        return modelOneInstance;
    }

    static async createERCBuyOrder(token, model, percent, price, address){
        // submit bid
        let escrow = price * percent;
        escrow = escrow + (escrow * 0.1)
        await token.approve(model.address, escrow, { from: address });
        await model.buy(price, percent, { from: address });
    }

    static async createERCSellOrder(token, model, percent, price, address){
        await model.sell(price, percent, { from: address });
    }

    static async getShares(model, owner){
        return (await model.getShares.call(owner)).toNumber();
    }

    static async createERCToken(name, symbol, amount, owner){
        const secondToken = await ERC20.new(name, symbol, amount, owner, {from: owner});
        return secondToken;
    }

}

module.exports = Helper;
