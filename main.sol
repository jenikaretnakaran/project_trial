//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "chatgpt.sol";
contract payroll is BonusToken {

address public superAdmin;

struct employee {
    uint256 id;
    uint256 salary;
    address salaryAddress;
    uint256 joiningDate;
    bool isRestricted;
}

mapping(address => uint256[]) public claimList;
mapping(address => uint256) public  adminList;
mapping(address => employee) public employeeList;


//Owner of contract
constructor() {
        superAdmin= msg.sender;
}
//superAdmin authorization
modifier onlySuperAdmin() {
        require(msg.sender == superAdmin,"Unauthorized identity");
        _;
}

//admins authorization
modifier onlyAdmin() {
        require(adminList[msg.sender] != 0,"Unauthorized identity");
        _;
}
// adding fund to the contract
function addFund(uint256 amount) public payable onlySuperAdmin {
    require(amount > 0 ,"no amount is specified");
    _mint(address(this),amount);
}

//adding admins
function addAdmin(uint256 _id, address _adminAdd) public onlySuperAdmin{
        require(adminList[_adminAdd] == 0,"admin already exists");
        adminList[_adminAdd] = _id;
}
//removing admins
function removeAdmin(address _admin) public onlySuperAdmin{
        require(adminList[_admin] != 0,"admin not exists");
        adminList[_admin] = 0;
        delete adminList[_admin];
}

//adding employees
function addEmployee(uint256 _id,uint256 _salary,address _address,bool _isRestricted) public onlySuperAdmin onlyAdmin {
        employee memory newEmployee = employee(_id, _salary, _address, block.timestamp, _isRestricted);
        employeeList[_address] = newEmployee;
        claimList[_address].push(block.timestamp);
}
//upgrade employee status
function upgradeStatus(uint256 _salary,address _key,bool isRestricted) public onlySuperAdmin onlyAdmin{
        employeeList[_key].salary = _salary;
        employeeList[_key].isRestricted = isRestricted;
}
//function to get last timeblock of salaryclaim
function salaryTimeStamp(address _key) public view returns(uint256) {
        require(claimList[_key].length > 0, "Array is empty");
        uint256 lastIndex = claimList[_key].length - 1;
        uint256 lastItem = claimList[_key][lastIndex];
        return lastItem;
}
//releasing fund to employees
function salaryClaim(address payable _key) public  {
        require(employeeList[_key].isRestricted = true ,"Unauthorized entry");
        


}

}
