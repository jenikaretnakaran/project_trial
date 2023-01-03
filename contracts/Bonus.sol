//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "contracts/Token.sol";
contract payroll is BonusToken{

using SafeMath for uint256;

address public superAdmin;

struct employee {
    uint256 id;
    uint256 salary;
    address salaryAddress;
    uint256 joiningDate;
    bool isRestricted;
}

mapping(address => uint256[]) public claimList;
mapping(address => uint256[]) public incentiveList;
// mapping(address => uint256) public  adminList;
mapping(address => employee) public employeeList;


//Owner of contract
constructor() {
        superAdmin= msg.sender;
}
//superAdmin authorization
modifier onlySuperAdmin() {
        require(msg.sender == superAdmin,"Unauthorized identity1");
        _;
}

// function to add fund to the contract
function addFund(uint256 amount) public payable onlySuperAdmin {
    require(amount > 0 ,"no amount is specified");
    _mint(address(this),amount);
//     transfer(address(this),amount);
}

// function to add employee details
function addEmployee(uint256 _id,
                uint256 _salary,
                address _address,
                bool _isRestricted) public onlySuperAdmin 
{       
        require(employeeList[_address].id != _id && employeeList[_address].salaryAddress != _address,"Employee with this /id already exists");
        employee memory newEmployee = employee(_id, _salary, _address, block.timestamp, _isRestricted);
        employeeList[_address] = newEmployee;
        claimList[_address].push(block.timestamp);
}
//function to upgrade employee status
function upgradeStatus(uint256 _salary,
                address _key,
                bool isRestricted) public onlySuperAdmin
{
        employeeList[_key].salary = _salary;
        employeeList[_key].isRestricted = isRestricted;
}
//function returns timestamp of the most recent time that the employee claimed their salary
function salaryTimeStamp(address _key) public view returns(uint256) {
        require(claimList[_key].length > 0, "Array is empty");
        uint256 lastIndex = claimList[_key].length - 1;
        uint256 lastItem = claimList[_key][lastIndex];
        return lastItem;
}
//function returns timestamp of the most recent time that the employee claimed their incentives
function incentiveTimeStamp(address _key) public view returns(uint256) {
        uint256 length = claimList[_key].length;
        require(claimList[_key][length - 1]-claimList[_key][length - 3] >= 15 seconds ,"15 seconds not reached");
        uint256 incentive = employeeList[_key].salary;
        uint256 result = incentive.mul(10).div(100);
        return result;

}

//view employeedata
function viewData(address _key) public view returns(uint256){
        return employeeList[_key].salary;
}

//function inherited from ERC20 contract to transfer tokens
function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = address(this);
        _transfer(owner, to, amount);
        return true;
}
//function for releasing salaryfund to employee
function salaryClaim(address payable _sender) public {
        require(employeeList[_sender].isRestricted == false ,"Unauthorized entry of employer");
        uint256 blockTime = salaryTimeStamp(_sender);
        require(block.timestamp - blockTime >= 5 seconds,"5 seconds not reached");
        uint256 salary = employeeList[_sender].salary;
        transfer(_sender,salary);
        claimList[_sender].push(block.timestamp);
}
//function for releasing incentivefund to employee
function incentiveClaim(address payable _sender) public {
        require(employeeList[_sender].isRestricted == false ,"Unauthorized entry of employer");
        uint256 _result = incentiveTimeStamp(_sender);
        transfer(_sender,_result);
        incentiveList[_sender].push(block.timestamp);

}
//function to get the totalsupply and balanceof tokens
function balanceAndSupply() public view returns(uint256,uint256){
        uint256 totalSupply = totalSupply();
        uint256 balanceOf = balanceOf(address(this));
        return (totalSupply,balanceOf); 
}
}
















// //adding admins
// function addAdmin(uint256 _id, address _adminAdd) public onlySuperAdmin{
//         require(adminList[_adminAdd] == 0,"admin already exists");
//         adminList[_adminAdd] = _id;
// }
// //removing admins
// function removeAdmin(address _admin) public onlySuperAdmin{
//         require(adminList[_admin] != 0,"admin not exists");
//         adminList[_admin] = 0;
//         delete adminList[_admin];
// }
// //admins authorization
// modifier onlyAdmin() {
//         require(Address.exists(adminList,msg.sender), "Account not exists");
//         _;
// }