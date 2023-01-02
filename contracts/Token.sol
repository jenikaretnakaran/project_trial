//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BonusToken is ERC20, Ownable {
    constructor() ERC20("Tether", "USDT") {
        _mint(address(this), 50 * 10**18);
    }
}