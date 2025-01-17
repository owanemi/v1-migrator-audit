// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {BUSD} from "src/COA-Contracts/Busd.sol";

contract BUSDTest is Test {
    BUSD busd;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() public {
        // Deploy the BUSD contract before each test
        busd = new BUSD();
    }

    function testMint() public {
        // Mint 1000 BUSD to 'user'
        uint256 mintAmount = 1000 ether;
        busd.mint(user1, mintAmount);

        // Assert the balance of 'user' is 1000 BUSD
        assertEq(busd.balanceOf(user1), mintAmount);
    }

    function testTransfer() public {
        // Mint tokens to user
        uint256 mintAmount = 1000 ether;
        busd.mint(user1, mintAmount);

        // Transfer 500 BUSD from user to user2
        vm.prank(user1); // Mock `msg.sender` as `user`
        busd.transfer(user2, 500 ether);

        // Assert the balances after transfer
        assertEq(busd.balanceOf(user1), 500 ether);
        assertEq(busd.balanceOf(user2), 500 ether);
    }

    function testApproveAndTransferFrom() public {
        // Mint tokens to user
        uint256 mintAmount = 1000 ether;
        busd.mint(user1, mintAmount);

        // Approve user2 to spend 500 BUSD on behalf of user
        vm.prank(user1);
        busd.approve(user2, 500 ether);

        // Check allowance
        assertEq(busd.allowance(user1, user2), 500 ether);

        // Transfer 300 BUSD from user to another address using user2
        address recipient = makeAddr("recipient");
        vm.prank(user2);
        busd.transferFrom(user1, recipient, 300 ether);

        // Assert balances and remaining allowance
        assertEq(busd.balanceOf(user1), 700 ether);
        assertEq(busd.balanceOf(recipient), 300 ether);
        assertEq(busd.allowance(user1, user2), 200 ether);
    }
}
