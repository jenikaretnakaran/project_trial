const main = async () => {
    const [owner,employee] = await hre.ethers.getSigners();
    const bonusContractFactory = await hre.ethers.getContractFactory("payroll");
    const bonusContract = await bonusContractFactory.deploy();
    await bonusContract.deployed();
    console.log("contract address:" , bonusContract.address);
    console.log("owner address:" , owner.address);

    const Web3 = require('web3');
    const web3 = new Web3();

    const userInput = 5000000000; // Replace with the value entered by the user
    const value = web3.utils.toHex(userInput);

    const _addFund = await bonusContract.addFund(value);
    await _addFund.wait();
    console.log("addedfund is :",userInput);

    const _balanceAndSupply = await bonusContract.balanceAndSupply();
    console.log(_balanceAndSupply);

    const _addEmployee = await bonusContract.addEmployee("1234","5000","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","false");
    await _addEmployee.wait();
    console.log(_addEmployee);

    const _upgradeStatus = await bonusContract.upgradeStatus("6000","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","false");
    await _upgradeStatus.wait();
    console.log("status updated");

    
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    }
    catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();