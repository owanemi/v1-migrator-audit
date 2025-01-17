// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test} from "forge-std/Test.sol";
import {PRLZ} from "src/COA-Contracts/Prlz.sol";

contract przTest is Test {
    PRLZ prz;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() public {
        // Deploy the prz contract before each test
        prz = new PRLZ();
    }

    function testMint() public {
        // Mint 1000 prz to 'user'
        uint256 mintAmount = 1000 ether;
        prz.mint(user1, mintAmount);

        // Assert the balance of 'user' is 1000 prz
        assertEq(prz.balanceOf(user1), mintAmount);
    }

    function testTransfer() public {
        // Mint tokens to user
        uint256 mintAmount = 1000 ether;
        prz.mint(user1, mintAmount);

        // Transfer 500 prz from user to user2
        vm.prank(user1); // Mock `msg.sender` as `user`
        prz.transfer(user2, 500 ether);

        // Assert the balances after transfer
        assertEq(prz.balanceOf(user1), 500 ether);
        assertEq(prz.balanceOf(user2), 500 ether);
    }

    function testApproveAndTransferFrom() public {
        // Mint tokens to user
        uint256 mintAmount = 1000 ether;
        prz.mint(user1, mintAmount);

        // Approve user2 to spend 500 prz on behalf of user
        vm.prank(user1);
        prz.approve(user2, 500 ether);

        // Check allowance
        assertEq(prz.allowance(user1, user2), 500 ether);

        // Transfer 300 prz from user to another address using user2
        address recipient = makeAddr("recipient");
        vm.prank(user2);
        prz.transferFrom(user1, recipient, 300 ether);

        // Assert balances and remaining allowance
        assertEq(prz.balanceOf(user1), 700 ether);
        assertEq(prz.balanceOf(recipient), 300 ether);
        assertEq(prz.allowance(user1, user2), 200 ether);
    }
}
