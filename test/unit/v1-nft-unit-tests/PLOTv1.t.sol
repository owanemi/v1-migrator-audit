// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { Test, console } from "forge-std/Test.sol";
import { ATLPLOT } from "src/COA-Contracts/land-nfts/PLOT.sol";
import { ERC20Mock } from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";

contract AtlPlotTest is Test {
    ATLPLOT public plot;
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

        // Deploy the plot contract
        vm.startPrank(owner);
        plot = new ATLPLOT(address(paymentToken));
        plot.setFeeCollector(owner);

        paymentToken.mint(user1, 900);
        
        vm.stopPrank();
    }

    function testMintPlot() public {
        // setCurrentBatch with admin
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        uint256 mintQuantity = 5;
        uint256 expectedPayment = initialPrice * mintQuantity;
        // Simulate payment from addr1 to the fee collector
        vm.startPrank(user1);
        paymentToken.approve(address(plot), expectedPayment);
        uint256 gasBefore = gasleft();

        // we check the fee collectors balance before
        uint256 feeCollectorBalanceBefore = paymentToken.balanceOf(feeCollector);


        // Mint tokens for addr1
        plot.mint(mintQuantity);

        uint256 gasAfter = gasleft();
        uint256 gasUsed = gasBefore - gasAfter;

        // Assert the mint was successful
        assertEq(plot.balanceOf(user1), mintQuantity);
        assertEq(plot.totalSupply(), mintQuantity);

        // Assert the payment was made
        uint256 feeCollectorBalanceAfter = paymentToken.balanceOf(feeCollector);
        assertEq(feeCollectorBalanceAfter, feeCollectorBalanceBefore + expectedPayment);

        // Log the gas used
        console.log("Gas used for minting:", gasUsed);
        vm.stopPrank();
    }

    function testSetCurrentBatchPlot() public {
        // Admin sets a new batch with quantity 200 and price 20
        vm.startPrank(owner);
        plot.setCurrentBatch(200, 20, true);
        vm.stopPrank();

        // Access the tuple returned by _currentBatch and destructure it
        (uint256 quantity, uint256 price, bool active) = plot._currentBatch();

        // Assert the batch parameters are correctly set
        assertEq(quantity, 200);
        assertEq(price, 20);
        assertTrue(active);
}


    function testSetTxFeePlot() public {
        // Admin sets a new transaction fee
        uint256 newTxFee = 5;

        vm.startPrank(owner);
        plot.setTxFee(newTxFee);
        vm.stopPrank();

        // (,,)
        // Assert the transaction fee was set correctly
        uint256 txFeeAmount = plot.txFeeAmount();
        assertEq(txFeeAmount, newTxFee);
    }

    function testSetPaymentTokenPlot() public {
        // Admin changes the payment token
        address newPaymentToken = makeAddr("newToken");
        vm.startPrank(owner);
        uint256 gasBeforeSetPaymentToken = gasleft();

        plot.setPaymentToken(newPaymentToken);
        
        uint256 gasAfterSetPaymentToken = gasleft();
        
        console.log("Gas used for setPaymentToken:", gasBeforeSetPaymentToken - gasAfterSetPaymentToken);
        vm.stopPrank();

        // Assert the payment token was updated correctly
        assertEq(plot.paymentToken(), newPaymentToken);
    }

    function testSetFreeParticipantControllerPlot() public {
        // Admin sets a free participant controller
        vm.startPrank(owner);

        plot.setFreeParticipantController(user2, true);

        vm.stopPrank();

        // Assert the user1 is now a free participant controller
        assertTrue(plot.freeParticipantControllers(user2));
    }

    function testSetFreeParticipantPlot() public {
        // Admin sets user2 as a free participant
        vm.startPrank(owner);
        uint256 gasBeforeSetFreeParticipant = gasleft();
        plot.setFreeParticipant(user2, true);
        uint256 gasAfterSetFreeParticipant = gasleft();
        console.log("Gas used for setFreeParticipant:", gasBeforeSetFreeParticipant - gasAfterSetFreeParticipant);
        vm.stopPrank();

        // Assert the user2 is now a free participant
        assertTrue(plot.freeParticipants(user2));
    }

    function testRevertIfMintingInactiveBatchPlot() public {
        // Set a new batch but with inactive status
        vm.startPrank(owner);
        plot.setCurrentBatch(100, 10, false);
        vm.stopPrank();

        // Try minting from user1, expect revert
        vm.startPrank(user1);
        vm.expectRevert("Current Batch is not active");
        plot.mint(5);
        vm.stopPrank();
    }

    function testSetCurrentBatchActivePlot() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(100, 10, true);
        plot.setCurrentBatchActive(false);
        vm.stopPrank();

        (, , bool active) = plot._currentBatch();
        assertFalse(active);
    }
    function testRevertIfNotOwnerPlot() public {
        // Test that only the owner can set the current batch
        vm.startPrank(user2);
        vm.expectRevert("Ownable: caller is not the owner");
        plot.setCurrentBatch(100, 10, true);
        vm.stopPrank();
    }

   function testSetFeeCollectorRevertIfZeroAddressPlot() public {
        vm.startPrank(owner);
        vm.expectRevert("Invalid address");
        plot.setFeeCollector(address(0));
        vm.stopPrank();
    }
}
