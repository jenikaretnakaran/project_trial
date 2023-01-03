const main = async () => {
    const [owner,employee] = await hre.ethers.getSigners();
    const bonusContractFactory = await hre.ethers.getContractFactory("payroll");
    const bonusContract = await bonusContractFactory.deploy();
    await bonusContract.deployed();
    
    console.log("contract address:" , bonusContract.address);
    console.log("owner address:" , owner.address);

    const Web3 = require('web3');
    const web3 = new Web3();

    const userInput = 1000000000;
    const value = web3.utils.toHex(userInput);

    const _addFund = await bonusContract.addFund(value);
    await _addFund.wait();
    console.log("addedfund is :",userInput);

    const _balanceAndSupply = await bonusContract.balanceAndSupply();
    console.log(_balanceAndSupply);

    const _addEmployee1 = await bonusContract.addEmployee("1234","5000","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",false);
    await _addEmployee1.wait();
    const _addedEmployee1 = await bonusContract.employeeList("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
    console.log(_addedEmployee1);

    // const _upgradeStatus = await bonusContract.upgradeStatus("6000","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",false);
    // await _upgradeStatus.wait();
    // const _upgraded = await bonusContract.employeeList("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
    // console.log(_upgraded);

    // const _addEmployee2 = await bonusContract.addEmployee("0001","4000","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",false);
    // await _addEmployee2.wait();
    // const _addedEmployee2 = await bonusContract.employeeList("0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db");
    // console.log(_addedEmployee2);

    const _salaryTimeStamp = await bonusContract.salaryTimeStamp("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
    console.log(_salaryTimeStamp);

    t

    // console.log("inside setTimeout");   
    //   async () => {
    //     const _salaryClaim = await bonusContract.salaryClaim("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
    //     await _salaryClaim.wait();
    //     const result = await bonusContract.claimList("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
    //     console.log(result);
    //   };
    //    console.log("After setTimeout");

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