// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { Test, console } from "forge-std/Test.sol";
import { ATLYARD } from "src/COA-Contracts/land-nfts/YARD.sol";
import { ERC20Mock } from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";

contract ATLYARDTest is Test {
    ATLYARD public yard;
    ERC20Mock public paymentToken;

    address public owner = makeAddr("owner");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public feeCollector = owner;

    uint256 public initialMintQuantity = 100;
    uint256 public initialPrice = 10;
    // uitn256 public 

    function setUp() public {
        // Deploy a mock ERC20 token
        paymentToken = new ERC20Mock("MockToken", "MKT", owner, 500e18);

        // Deploy the yard contract
        vm.startPrank(owner);
        yard = new ATLYARD(address(paymentToken));
        yard.setFeeCollector(owner);

        paymentToken.mint(user1, 900);
        
        vm.stopPrank();
    }

    function testMintYard() public {
        // setCurrentBatch with admin
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        uint256 mintQuantity = 5;
        uint256 expectedPayment = initialPrice * mintQuantity;
        // Simulate payment from addr1 to the fee collector
        vm.startPrank(user1);
        paymentToken.approve(address(yard), expectedPayment);
        uint256 gasBefore = gasleft();

        // we check the fee collectors balance before
        uint256 feeCollectorBalanceBefore = paymentToken.balanceOf(feeCollector);


        // Mint tokens for addr1
        yard.mint(mintQuantity);

        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;

        // Assert the mint was successful
        assertEq(yard.balanceOf(user1), mintQuantity);
        assertEq(yard.totalSupply(), mintQuantity);

        // Assert the payment was made
        uint256 feeCollectorBalanceAfter = paymentToken.balanceOf(feeCollector);
        assertEq(feeCollectorBalanceAfter, feeCollectorBalanceBefore + expectedPayment);

        // Log the gas used
        console.log("Gas used for minting:", gasUsed);
        vm.stopPrank();
    }

    function testSetCurrentBatchYard() public {
        // Admin sets a new batch with quantity 200 and price 20
        vm.startPrank(owner);
        yard.setCurrentBatch(200, 20, true);
        vm.stopPrank();

        // Access the tuple returned by _currentBatch and destructure it
        (uint256 quantity, uint256 price, bool active) = yard._currentBatch();

        // Assert the batch parameters are correctly set
        assertEq(quantity, 200);
        assertEq(price, 20);
        assertTrue(active);
}


    function testSetTxFeeYard() public {
        // Admin sets a new transaction fee
        uint256 newTxFee = 5;

        vm.startPrank(owner);
        yard.setTxFee(newTxFee);
        vm.stopPrank();

        // (,,)
        // Assert the transaction fee was set correctly
        uint256 txFeeAmount = yard.txFeeAmount();
        assertEq(txFeeAmount, newTxFee);
    }

    function testSetPaymentTokenYard() public {
        // Admin changes the payment token
        address newPaymentToken = makeAddr("newToken");
        vm.startPrank(owner);
        uint256 gasBeforeSetPaymentToken = gasleft();

        yard.setPaymentToken(newPaymentToken);
        
        uint256 gasAfterSetPaymentToken = gasleft();
        
        console.log("Gas used for setPaymentToken:", gasBeforeSetPaymentToken - gasAfterSetPaymentToken);
        vm.stopPrank();

        // Assert the payment token was updated correctly
        assertEq(yard.paymentToken(), newPaymentToken);
    }

    function testSetFreeParticipantController() public {
        // Admin sets a free participant controller
        vm.startPrank(owner);

        yard.setFreeParticipantController(user2, true);

        vm.stopPrank();

        // Assert the user1 is now a free participant controller
        assertTrue(yard.freeParticipantControllers(user2));
    }

    function testSetFreeParticipant() public {
        // Admin sets user2 as a free participant
        vm.startPrank(owner);
        uint256 gasBeforeSetFreeParticipant = gasleft();
        yard.setFreeParticipant(user2, true);
        uint256 gasAfterSetFreeParticipant = gasleft();
        console.log("Gas used for setFreeParticipant:", gasBeforeSetFreeParticipant - gasAfterSetFreeParticipant);
        vm.stopPrank();

        // Assert the user2 is now a free participant
        assertTrue(yard.freeParticipants(user2));
    }

    function testRevertIfMintingInactiveBatchYard() public {
        // Set a new batch but with inactive status
        vm.startPrank(owner);
        yard.setCurrentBatch(100, 10, false);
        vm.stopPrank();

        // Try minting from user1, expect revert
        vm.startPrank(user1);
        vm.expectRevert("Current Batch is not active");
        yard.mint(5);
        vm.stopPrank();
    }

    function testSetCurrentBatchActiveYard() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(100, 10, true);
        yard.setCurrentBatchActive(false);
        vm.stopPrank();

        (, , bool active) = yard._currentBatch();
        assertFalse(active);
    }
    function testRevertIfNotOwnerYard() public {
        // Test that only the owner can set the current batch
        vm.startPrank(user2);
        vm.expectRevert("Ownable: caller is not the owner");
        yard.setCurrentBatch(100, 10, true);
        vm.stopPrank();
    }

   function testSetFeeCollectorRevertIfZeroAddressYard() public {
        vm.startPrank(owner);
        vm.expectRevert("Invalid address");
        yard.setFeeCollector(address(0));
        vm.stopPrank();
    }
}
