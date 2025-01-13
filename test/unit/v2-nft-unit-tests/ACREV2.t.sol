// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { ACREV2 } from "src/COA-Contracts/land-nfts-v2/ACREV2.sol";
import { ERC20Mock } from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";

contract AcreV2Test is Test {
    ACREV2 public acre;
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

        // Deploy and initialize the acre contract
        vm.startPrank(owner);
        acre = new ACREV2();
        acre.initialize(address(paymentToken));

        // Grant SIGNER_ROLE to the owner
        acre.grantRole(SIGNER_ROLE, owner);

        // Set fee collector and mint tokens for users
        acre.setFeeCollector(owner);
        paymentToken.mint(user1, 1000e18);
        paymentToken.mint(user2, 1000e18);
        vm.stopPrank();
    }

    function testInitializationAcreV2() public {
        assertEq(acre.paymentToken(), address(paymentToken), "Payment token address mismatch");
        assertEq(acre.feeCollector(), owner, "Fee collector mismatch");
        assertEq(acre.txFeeAmount(), 0, "Default transaction fee should be 0");
        assertEq(acre.maxBuyAmount(), 10, "Default max buy amount should be 10");
    }

    // Test batch creation and management
    function testBatchCreationAcreV2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        
        (uint256 price, uint256 quantity, uint256 startIndex, uint256 batchId, bool active) = acre.currentBatch();
        
        assertEq(quantity, initialMintQuantity, "Batch quantity mismatch");
        assertEq(price, initialPrice, "Batch price mismatch");
        assertEq(startIndex, 0, "Start index should be 0");
        assertEq(batchId, 0, "First batch ID should be 0");
        assertTrue(active, "Batch should be active");
        vm.stopPrank();
    }

    function testCannotCreateBatchWithExistingQuantityAcreV2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        
        vm.expectRevert(); // Should revert with CurrentBatchNotActive
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();
    }

    function testSuccessfulMintAcrev2() public {
        // Setup
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        uint256 ownerInitialBalance = paymentToken.balanceOf(owner);
        vm.stopPrank();

        // Approve tokens
        vm.startPrank(user1);
        paymentToken.approve(address(acre), initialPrice * 2);
        
        // Mint NFTs
        acre.mint(2);
        
        // Verify NFT balance
        assertEq(acre.balanceOf(user1), 2, "User should have 2 NFTs");
        
        // Verify token payment
        uint256 expectedBalance = ownerInitialBalance + (initialPrice * 2);
        assertEq(
            paymentToken.balanceOf(owner),
            expectedBalance,
            "Owner should receive correct payment amount"
        );
        vm.stopPrank();
    }

    function testCannotMintWhenInactiveAcrev2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, false);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(acre), initialPrice);
        vm.expectRevert(ACREV2.CurrentBatchNotActive.selector);
        acre.mint(1);
        vm.stopPrank();
    }

    function testCannotMintZeroQuantityAcrev2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert(ACREV2.QuantityMustBeAboveZero.selector);
        acre.mint(0);
        vm.stopPrank();
    }

    function testCannotMintAboveMaxBuyAmountAcrev2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(acre), initialPrice * 11);
        vm.expectRevert(ACREV2.MaxBuyAmountLimitReached.selector);
        acre.mint(11);
        vm.stopPrank();
    }

    // Test free participant functionality
    function testFreeParticipantMintAcrev2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        acre.setFreeParticipant(user1, true);
        vm.stopPrank();

        vm.startPrank(user1);
        acre.mint(2);
        assertEq(acre.balanceOf(user1), 2, "Free participant should receive NFTs");
        assertEq(paymentToken.balanceOf(user1), 1000e18, "Free participant should not pay");
        vm.stopPrank();
    }


    function testSetPaymentTokenAcrev2() public {
        address newToken = makeAddr("newToken");
        
        vm.startPrank(owner);
        acre.setPaymentToken(newToken);
        assertEq(acre.paymentToken(), newToken, "Payment token should be updated");
        vm.stopPrank();
    }

    function testSetFeeCollectorAcrev2() public {
        vm.startPrank(owner);
        acre.setFeeCollector(user2);
        assertEq(acre.feeCollector(), user2, "Fee collector should be updated");
        vm.stopPrank();
    }

    function testBatchLifecycleAcrev2() public {
        vm.startPrank(owner);
        
        // Create batch
        acre.setCurrentBatch(initialMintQuantity, initialPrice, true);
        
        // Deactivate batch
        acre.setCurrentBatchActive(false);
        (,,,, bool active) = acre.currentBatch();
        assertFalse(active, "Batch should be inactive");
        
        // Reactivate batch
        acre.setCurrentBatchActive(true);
        (,,,, active) = acre.currentBatch();
        assertTrue(active, "Batch should be active again");
        
        vm.stopPrank();
    }

    function testMintExhaustionAcrev2() public {
        vm.startPrank(owner);
        acre.setCurrentBatch(2, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(acre), initialPrice * 2);
        acre.mint(2);
        
        vm.expectRevert(ACREV2.NoMoreTokensLeft.selector);
        acre.mint(1);
        vm.stopPrank();
    }

    // Test transaction fee functionality
    function testSetAndCollectTxFeeAcrev2() public {
        uint256 newFee = 1 ether;
        
        vm.startPrank(owner);
        acre.setTxFee(newFee);
        assertEq(acre.txFeeAmount(), newFee, "Transaction fee should be updated");
        vm.stopPrank();
    }
}