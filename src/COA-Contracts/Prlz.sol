// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// @audit -informational- best pratice to use named imports
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract PRLZ is ERC20 {
    constructor() ERC20("Busd", "BUSD") {}

    function mint(address _to, uint256 _amount) external {
        _mint(_to, _amount);
    }
}
