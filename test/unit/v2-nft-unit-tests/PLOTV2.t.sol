// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {PLOTV2} from "src/COA-Contracts/land-nfts-v2/PLOTV2.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";

contract PlotV2Test is Test {
    PLOTV2 public plot;
    ERC20Mock public paymentToken;

    address public owner = makeAddr("owner");
    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public feeCollector = owner;

    uint256 public initialMintQuantity = 100;
    uint256 public initialPrice = 10 ether;
    bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");

    function setUp() public {
        // Deploy a mock ERC20 token
        paymentToken = new ERC20Mock("MockToken", "MKT", owner, 500e18);

        // Deploy and initialize the plot contract
        vm.startPrank(owner);
        plot = new PLOTV2();
        plot.initialize(address(paymentToken));

        // Grant SIGNER_ROLE to the owner
        plot.grantRole(SIGNER_ROLE, owner);

        // Set fee collector and mint tokens for users
        plot.setFeeCollector(owner);
        paymentToken.mint(user1, 1000e18);
        paymentToken.mint(user2, 1000e18);
        vm.stopPrank();
    }

    function testInitializationPlotV2() public {
        assertEq(plot.paymentToken(), address(paymentToken), "Payment token address mismatch");
        assertEq(plot.feeCollector(), owner, "Fee collector mismatch");
        assertEq(plot.txFeeAmount(), 0, "Default transaction fee should be 0");
        assertEq(plot.maxBuyAmount(), 10, "Default max buy amount should be 10");
    }

    // Test batch creation and management
    function testBatchCreationPlotV2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);

        (uint256 price, uint256 quantity, uint256 startIndex, uint256 batchId, bool active) = plot.currentBatch();

        assertEq(quantity, initialMintQuantity, "Batch quantity mismatch");
        assertEq(price, initialPrice, "Batch price mismatch");
        assertEq(startIndex, 0, "Start index should be 0");
        assertEq(batchId, 0, "First batch ID should be 0");
        assertTrue(active, "Batch should be active");
        vm.stopPrank();
    }

    function testCannotCreateBatchWithExistingQuantityPlotV2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);

        vm.expectRevert(); // Should revert with CurrentBatchNotActive
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();
    }

    function testSuccessfulMintPlotv2() public {
        // Setup
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        uint256 ownerInitialBalance = paymentToken.balanceOf(owner);
        vm.stopPrank();

        // Approve tokens
        vm.startPrank(user1);
        paymentToken.approve(address(plot), initialPrice * 2);

        // Mint NFTs
        plot.mint(2);

        // Verify NFT balance
        assertEq(plot.balanceOf(user1), 2, "User should have 2 NFTs");

        // Verify token payment
        uint256 expectedBalance = ownerInitialBalance + (initialPrice * 2);
        assertEq(paymentToken.balanceOf(owner), expectedBalance, "Owner should receive correct payment amount");
        vm.stopPrank();
    }

    function testCannotMintWhenInactivePlotv2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, false);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(plot), initialPrice);
        vm.expectRevert(PLOTV2.CurrentBatchNotActive.selector);
        plot.mint(1);
        vm.stopPrank();
    }

    function testCannotMintZeroQuantityPlotv2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert(PLOTV2.QuantityMustBeAboveZero.selector);
        plot.mint(0);
        vm.stopPrank();
    }

    function testCannotMintAboveMaxBuyAmountPlotv2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(plot), initialPrice * 11);
        vm.expectRevert(PLOTV2.MaxBuyAmountLimitReached.selector);
        plot.mint(11);
        vm.stopPrank();
    }

    // Test free participant functionality
    function testFreeParticipantMintPlotv2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);
        plot.setFreeParticipant(user1, true);
        vm.stopPrank();

        vm.startPrank(user1);
        plot.mint(2);
        assertEq(plot.balanceOf(user1), 2, "Free participant should receive NFTs");
        assertEq(paymentToken.balanceOf(user1), 1000e18, "Free participant should not pay");
        vm.stopPrank();
    }

    function testSetPaymentTokenPlotv2() public {
        address newToken = makeAddr("newToken");

        vm.startPrank(owner);
        plot.setPaymentToken(newToken);
        assertEq(plot.paymentToken(), newToken, "Payment token should be updated");
        vm.stopPrank();
    }

    function testSetFeeCollectorPlotv2() public {
        vm.startPrank(owner);
        plot.setFeeCollector(user2);
        assertEq(plot.feeCollector(), user2, "Fee collector should be updated");
        vm.stopPrank();
    }

    function testBatchLifecyclePlotv2() public {
        vm.startPrank(owner);

        // Create batch
        plot.setCurrentBatch(initialMintQuantity, initialPrice, true);

        // Deactivate batch
        plot.setCurrentBatchActive(false);
        (,,,, bool active) = plot.currentBatch();
        assertFalse(active, "Batch should be inactive");

        // Reactivate batch
        plot.setCurrentBatchActive(true);
        (,,,, active) = plot.currentBatch();
        assertTrue(active, "Batch should be active again");

        vm.stopPrank();
    }

    function testMintExhaustionPlotv2() public {
        vm.startPrank(owner);
        plot.setCurrentBatch(2, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(plot), initialPrice * 2);
        plot.mint(2);

        vm.expectRevert(PLOTV2.NoMoreTokensLeft.selector);
        plot.mint(1);
        vm.stopPrank();
    }

    // Test transaction fee functionality
    function testSetAndCollectTxFeePlotv2() public {
        uint256 newFee = 1 ether;

        vm.startPrank(owner);
        plot.setTxFee(newFee);
        assertEq(plot.txFeeAmount(), newFee, "Transaction fee should be updated");
        vm.stopPrank();
    }
}
