// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {YARDV2} from "src/COA-Contracts/land-nfts-v2/YARDV2.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";

contract YardV2Test is Test {
    YARDV2 public yard;
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

        // Deploy and initialize the yard contract
        vm.startPrank(owner);
        yard = new YARDV2();
        yard.initialize(address(paymentToken));

        // Grant SIGNER_ROLE to the owner
        yard.grantRole(SIGNER_ROLE, owner);

        // Set fee collector and mint tokens for users
        yard.setFeeCollector(owner);
        paymentToken.mint(user1, 1000e18);
        paymentToken.mint(user2, 1000e18);
        vm.stopPrank();
    }

    function testInitializationyardV2() public {
        assertEq(yard.paymentToken(), address(paymentToken), "Payment token address mismatch");
        assertEq(yard.feeCollector(), owner, "Fee collector mismatch");
        assertEq(yard.txFeeAmount(), 0, "Default transaction fee should be 0");
        assertEq(yard.maxBuyAmount(), 10, "Default max buy amount should be 10");
    }

    // Test batch creation and management
    function testBatchCreationyardV2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);

        (uint256 price, uint256 quantity, uint256 startIndex, uint256 batchId, bool active) = yard.currentBatch();

        assertEq(quantity, initialMintQuantity, "Batch quantity mismatch");
        assertEq(price, initialPrice, "Batch price mismatch");
        assertEq(startIndex, 0, "Start index should be 0");
        assertEq(batchId, 0, "First batch ID should be 0");
        assertTrue(active, "Batch should be active");
        vm.stopPrank();
    }

    function testCannotCreateBatchWithExistingQuantityyardV2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);

        vm.expectRevert(); // Should revert with CurrentBatchNotActive
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();
    }

    function testSuccessfulMintyardv2() public {
        // Setup
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        uint256 ownerInitialBalance = paymentToken.balanceOf(owner);
        vm.stopPrank();

        // Approve tokens
        vm.startPrank(user1);
        paymentToken.approve(address(yard), initialPrice * 2);

        // Mint NFTs
        yard.mint(2);

        // Verify NFT balance
        assertEq(yard.balanceOf(user1), 2, "User should have 2 NFTs");

        // Verify token payment
        uint256 expectedBalance = ownerInitialBalance + (initialPrice * 2);
        assertEq(paymentToken.balanceOf(owner), expectedBalance, "Owner should receive correct payment amount");
        vm.stopPrank();
    }

    function testCannotMintWhenInactiveyardv2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, false);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(yard), initialPrice);
        vm.expectRevert(YARDV2.CurrentBatchNotActive.selector);
        yard.mint(1);
        vm.stopPrank();
    }

    function testCannotMintZeroQuantityyardv2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        vm.expectRevert(YARDV2.QuantityMustBeAboveZero.selector);
        yard.mint(0);
        vm.stopPrank();
    }

    function testCannotMintAboveMaxBuyAmountyardv2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(yard), initialPrice * 11);
        vm.expectRevert(YARDV2.MaxBuyAmountLimitReached.selector);
        yard.mint(11);
        vm.stopPrank();
    }

    // Test free participant functionality
    function testFreeParticipantMintyardv2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);
        yard.setFreeParticipant(user1, true);
        vm.stopPrank();

        vm.startPrank(user1);
        yard.mint(2);
        assertEq(yard.balanceOf(user1), 2, "Free participant should receive NFTs");
        assertEq(paymentToken.balanceOf(user1), 1000e18, "Free participant should not pay");
        vm.stopPrank();
    }

    function testSetPaymentTokenyardv2() public {
        address newToken = makeAddr("newToken");

        vm.startPrank(owner);
        yard.setPaymentToken(newToken);
        assertEq(yard.paymentToken(), newToken, "Payment token should be updated");
        vm.stopPrank();
    }

    function testSetFeeCollectoryardv2() public {
        vm.startPrank(owner);
        yard.setFeeCollector(user2);
        assertEq(yard.feeCollector(), user2, "Fee collector should be updated");
        vm.stopPrank();
    }

    function testBatchLifecycleyardv2() public {
        vm.startPrank(owner);

        // Create batch
        yard.setCurrentBatch(initialMintQuantity, initialPrice, true);

        // Deactivate batch
        yard.setCurrentBatchActive(false);
        (,,,, bool active) = yard.currentBatch();
        assertFalse(active, "Batch should be inactive");

        // Reactivate batch
        yard.setCurrentBatchActive(true);
        (,,,, active) = yard.currentBatch();
        assertTrue(active, "Batch should be active again");

        vm.stopPrank();
    }

    function testMintExhaustionyardv2() public {
        vm.startPrank(owner);
        yard.setCurrentBatch(2, initialPrice, true);
        vm.stopPrank();

        vm.startPrank(user1);
        paymentToken.approve(address(yard), initialPrice * 2);
        yard.mint(2);

        vm.expectRevert(YARDV2.NoMoreTokensLeft.selector);
        yard.mint(1);
        vm.stopPrank();
    }

    // Test transaction fee functionality
    function testSetAndCollectTxFeeyardv2() public {
        uint256 newFee = 1 ether;

        vm.startPrank(owner);
        yard.setTxFee(newFee);
        assertEq(yard.txFeeAmount(), newFee, "Transaction fee should be updated");
        vm.stopPrank();
    }
}
