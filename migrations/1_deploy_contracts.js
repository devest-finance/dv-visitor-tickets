const DvVisitorTicket = artifacts.require("DvVisitorTicket");
const DvVisitorTicketFactory = artifacts.require("DvVisitorTicketFactory");
const ERC20PresetFixedSupply = artifacts.require("ERC20PresetFixedSupply");

module.exports = function(deployer) {
    if (deployer.network === 'development') {
        deployer.deploy(DvVisitorTicketFactory)
            .then(() => deployer.deploy(ERC20PresetFixedSupply, "ERC20 Token", "TKO", 1000000000000, "0xECF5A576A949aEE5915Afb60E0e62D09825Cd61B"))
            .then(() => ERC20PresetFixedSupply.deployed())
            .then(async _instance => {})
            .then(() => DvVisitorTicketFactory.deployed())
            .then(async _instance => {
                    const devestDAOImp = await _instance.issue("0x0000000000000000000000000000000000000000", "DeVest DAO", "DeVest DAO");
                    //await _instance.setRoot(devestDAOImp.logs[0].args[1], { from: "0xECF5A576A949aEE5915Afb60E0e62D09825Cd61B" });
                    //await _instance.setRoyalty(100000000);
                    const devestDAO = await DvVisitorTicket.at(devestDAOImp.logs[0].args[1]);
                    const owner = await devestDAO.owner();
                    // 10000000,
                    await devestDAO.initialize(10, 0, { from: "0xECF5A576A949aEE5915Afb60E0e62D09825Cd61B" });

                    // set fee on factory and also attach devest-dao as recipient
                    await _instance.setFee(10000000, 10000000);
                    await _instance.setRecipient(devestDAO.address);
                }
            )
    } else {
      deployer.deploy(DvVisitorTicketFactory)
          .then(() => DvVisitorTicketFactory.deployed())
          .then(async _instance => {
              //await _instance.setFee(10000000);
          });
  }
};
