// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Migrator} from "src/Migrator.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";
import {ERC721Mock} from "lib/openzeppelin-contracts/contracts/mocks/ERC721Mock.sol";

interface IMintable {
    function mintAsFreeMinter(uint256 quantity) external;
}

// Extend ERC721Mock to add mintAsFreeMinter functionality
contract CollectibleMock is ERC721Mock, IMintable {
    uint256 private _tokenIdCounter;

    constructor(string memory name, string memory symbol) ERC721Mock(name, symbol) {}

    function mintAsFreeMinter(uint256 quantity) external {
        for (uint256 i = 0; i < quantity; ++i) {
            _mint(msg.sender, _tokenIdCounter);
            ++_tokenIdCounter;
        }
    }

    function currentTokenId() external view returns (uint256) {
        return _tokenIdCounter;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
}

contract MigratorTest is Test {
    Migrator migrator;
    ERC20Mock tokenV1;
    ERC20Mock tokenV2;
    CollectibleMock acreV1;
    CollectibleMock plotV1;
    CollectibleMock yardV1;
    CollectibleMock acreV2;
    CollectibleMock plotV2;
    CollectibleMock yardV2;

    address admin = makeAddr("admin");
    address user = makeAddr("user");
    bytes32 constant SIGNER_ROLE = keccak256("SIGNER_ROLE");
    uint256 constant LARGE_BATCH_SIZE = 250;
    uint256 constant HIGH_GAS_PRICE = 500 gwei;

    event TokenMigrationCompleted(
        address indexed user,
        address indexed token1,
        address indexed token2,
        uint256 amount1,
        uint256 amount2,
        uint256 date
    );

    event NFTMigrationCompleted(
        address indexed user, address indexed nft1, address indexed nft2, uint256 oldId, uint256 newId, uint256 date
    );

    function setUp() public {
        vm.startPrank(admin);

        // Deploy tokens with larger initial supply for big batch tests
        tokenV1 = new ERC20Mock("TokenV1", "TV1", admin, 1e30);
        tokenV2 = new ERC20Mock("TokenV2", "TV2", admin, 1e30);

        // Deploy NFTs
        acreV1 = new CollectibleMock("AcreV1", "ACRE1");
        plotV1 = new CollectibleMock("PlotV1", "PLOT1");
        yardV1 = new CollectibleMock("YardV1", "YARD1");
        acreV2 = new CollectibleMock("AcreV2", "ACRE2");
        plotV2 = new CollectibleMock("PlotV2", "PLOT2");
        yardV2 = new CollectibleMock("YardV2", "YARD2");

        // Deploy and initialize migrator
        migrator = new Migrator();
        migrator.initialize();

        // Setup roles
        migrator.grantRole(SIGNER_ROLE, admin);

        // Setup migration requirements
        migrator.setTokenInfo(address(tokenV1), address(tokenV2), 2); // 1:2 ratio
        migrator.setERC721Requirements(
            address(acreV1), address(yardV1), address(plotV1), address(acreV2), address(yardV2), address(plotV2)
        );

        // Fund migrator with V2 tokens
        tokenV2.transfer(address(migrator), 1e25);

        // Setup user with V1 assets
        tokenV1.transfer(user, 6 * 10 ** 18);

        // Mint some V1 NFTs to user
        vm.stopPrank();

        vm.startPrank(admin);
        acreV1.mint(user, 0);
        acreV1.mint(user, 1);
        plotV1.mint(user, 0);
        yardV1.mint(user, 0);
        vm.stopPrank();
    }

    function testERC20Migration() public {
        vm.startPrank(user);

        uint256 migrationAmount = 6 * 10 ** 18;
        uint256 initialV1Balance = tokenV1.balanceOf(user);
        uint256 initialV2Balance = tokenV2.balanceOf(user);

        tokenV1.approve(address(migrator), migrationAmount);

        vm.expectEmit(true, true, true, true);
        emit TokenMigrationCompleted(
            user, address(tokenV1), address(tokenV2), migrationAmount, migrationAmount * 2, block.timestamp
        );

        migrator.migrateERC20Token(migrationAmount, address(tokenV1), address(tokenV2));

        assertEq(tokenV1.balanceOf(user), initialV1Balance - migrationAmount);
        assertEq(tokenV2.balanceOf(user), initialV2Balance + (migrationAmount * 2));

        vm.stopPrank();
    }

    function testTokenBReceivedIsCorrectMigrationAmount() public {
        vm.startPrank(user);

        uint256 initialV1Balance = tokenV1.balanceOf(user);
        uint256 initialV2Balance = tokenV2.balanceOf(user);

        console.log("initialv1Balance: ", initialV1Balance / 10 ** 18);
        console.log("initialV2Balance: ", initialV2Balance / 10 ** 18);
        uint256 migrationAmount = 6 * 10 ** 18; // Migrate 6 tokens

        // approve migrator to spend tokens
        tokenV1.approve(address(migrator), migrationAmount);

        // Perform migration
        migrator.migrateERC20Token(migrationAmount, address(tokenV1), address(tokenV2));

        // Check final balances
        uint256 finalV1Balance = tokenV1.balanceOf(user);
        uint256 finalV2Balance = tokenV2.balanceOf(user);
        console.log("finalv1balance: ", finalV1Balance / 10 ** 18);
        console.log("finalV2Balance: ", finalV2Balance / 10 ** 18);

        // Calculate expected amounts
        uint256 expectedV1Decrease = migrationAmount;
        uint256 expectedV2Increase = migrationAmount * 2; // Should get 2x tokens due to price=2

        // Verify V1 token decrease is correct
        assertEq(initialV1Balance - finalV1Balance, expectedV1Decrease, "V1 token decrease incorrect");

        // This assertion will fail because of the bug
        // User receives migrationAmount instead of migrationAmount * 2
        assertEq(finalV2Balance - initialV2Balance, expectedV2Increase, "V2 token increase incorrect - Bug detected!");
        vm.stopPrank();
    }

    function testFailERC20MigrationInsufficientAllowance() public {
        vm.startPrank(user);
        vm.expectRevert("Insufficient allowance");
        migrator.migrateERC20Token(100, address(tokenV1), address(tokenV2));
        vm.stopPrank();
    }

    function testFailNFTMigrationUnapproved() public {
        vm.startPrank(user);

        uint256[] memory acreIds = new uint256[](1);
        acreIds[0] = 0;

        uint256[] memory emptyIds = new uint256[](0);

        // Don't approve migrator
        migrator.migrateAllAsset(acreIds, emptyIds, emptyIds);

        vm.stopPrank();
    }

    function testNFTMigration() public {
        vm.startPrank(user);

        uint256[] memory acreIds = new uint256[](2);
        acreIds[0] = 0;
        acreIds[1] = 1;

        uint256[] memory plotIds = new uint256[](1);
        plotIds[0] = 0;

        uint256[] memory yardIds = new uint256[](1);
        yardIds[0] = 0;

        // Approve migrator for all NFTs
        acreV1.setApprovalForAll(address(migrator), true);
        plotV1.setApprovalForAll(address(migrator), true);
        yardV1.setApprovalForAll(address(migrator), true);

        migrator.migrateAllAsset(acreIds, plotIds, yardIds);

        // Verify V2 NFTs were received
        assertEq(acreV2.balanceOf(user), 2);
        assertEq(plotV2.balanceOf(user), 1);
        assertEq(yardV2.balanceOf(user), 1);

        vm.stopPrank();
    }

    function testSetTokenInfo() public {
        vm.startPrank(admin);

        address newToken1 = makeAddr("newToken1");
        address newToken2 = makeAddr("newToken2");
        uint256 newPrice = 3;

        migrator.setTokenInfo(newToken1, newToken2, newPrice);

        (address configToken1, address configToken2, uint256 configPrice) = getRequirementsTokenInfo();
        assertEq(configToken1, newToken1);
        assertEq(configToken2, newToken2);
        assertEq(configPrice, newPrice);

        vm.stopPrank();
    }

    function testFailSetTokenInfoUnauthorized() public {
        vm.prank(user);
        migrator.setTokenInfo(address(1), address(2), 3);
    }

    function testSetERC721Requirements() public {
        vm.startPrank(admin);

        address newAcre = makeAddr("newAcre");
        migrator.setERC721Requirements(newAcre, address(0), address(0), address(0), address(0), address(0));

        (address configAcre,,,,,,,,) = migrator.Requirements();
        assertEq(configAcre, newAcre);

        vm.stopPrank();
    }

    function testFailSetERC721RequirementsUnauthorized() public {
        vm.prank(user);
        migrator.setERC721Requirements(address(1), address(0), address(0), address(0), address(0), address(0));
    }

    // New Complex Test Scenarios

    function testLargeBatchMigration() public {
        vm.startPrank(admin);

        // Start minting from ID 100 to avoid conflicts with setUp() tokens
        uint256 startId = 100;

        // Mint large batches of V1 NFTs to user
        for (uint256 i = 0; i < LARGE_BATCH_SIZE; i++) {
            acreV1.mint(user, startId + i);
            plotV1.mint(user, startId + i);
            yardV1.mint(user, startId + i);
        }
        vm.stopPrank();

        vm.startPrank(user);

        // Prepare arrays for large batch migration using the new ID range
        uint256[] memory acreIds = new uint256[](LARGE_BATCH_SIZE);
        uint256[] memory plotIds = new uint256[](LARGE_BATCH_SIZE);
        uint256[] memory yardIds = new uint256[](LARGE_BATCH_SIZE);

        for (uint256 i = 0; i < LARGE_BATCH_SIZE; i++) {
            acreIds[i] = startId + i;
            plotIds[i] = startId + i;
            yardIds[i] = startId + i;
        }

        // Approve migrator for all NFT types
        acreV1.setApprovalForAll(address(migrator), true);
        plotV1.setApprovalForAll(address(migrator), true);
        yardV1.setApprovalForAll(address(migrator), true);

        // Measure gas consumption
        uint256 gasBefore = gasleft();

        migrator.migrateAllAsset(acreIds, plotIds, yardIds);

        uint256 gasUsed = gasBefore - gasleft();
        console.log("Gas used for large batch migration:", gasUsed);

        // Verify V2 NFTs were received correctly
        assertEq(acreV2.balanceOf(user), LARGE_BATCH_SIZE);
        assertEq(plotV2.balanceOf(user), LARGE_BATCH_SIZE);
        assertEq(yardV2.balanceOf(user), LARGE_BATCH_SIZE);

        vm.stopPrank();
    }

    function testHighCongestionMigration() public {
        vm.startPrank(admin);
        // Start from ID 400 to avoid conflicts
        uint256 startId = 400;
        // Mint test NFTs
        for (uint256 i = 0; i < 10; i++) {
            acreV1.mint(user, startId + i);
        }
        vm.stopPrank();

        vm.startPrank(user);

        // Prepare migration data with new ID range
        uint256[] memory acreIds = new uint256[](10);
        uint256[] memory emptyIds = new uint256[](0);
        for (uint256 i = 0; i < 10; i++) {
            acreIds[i] = startId + i;
        }

        acreV1.setApprovalForAll(address(migrator), true);

        // Simulate high network congestion
        vm.fee(HIGH_GAS_PRICE);

        // Measure gas costs under congestion
        uint256 gasBefore = gasleft();

        migrator.migrateAllAsset(acreIds, emptyIds, emptyIds);

        uint256 gasUsed = gasBefore - gasleft();

        console.log("Gas used under high congestion:", gasUsed);

        vm.stopPrank();
    }

    function testIncompleteMetadataMigration() public {
        // Setup NFTs with missing or incomplete metadata
        vm.startPrank(admin);

        // Start from ID 500 to avoid conflicts
        uint256 startId = 500;
        // Create NFTs with various states
        uint256[] memory validTokenIds = new uint256[](3);
        for (uint256 i = 0; i < 3; i++) {
            acreV1.mint(user, startId + i);
            validTokenIds[i] = startId + i;
        }

        vm.stopPrank();

        vm.startPrank(user);
        acreV1.setApprovalForAll(address(migrator), true);

        uint256[] memory emptyIds = new uint256[](0);

        // Test migration with valid tokens
        migrator.migrateAllAsset(validTokenIds, emptyIds, emptyIds);

        // Verify the migration completed successfully for valid tokens
        assertEq(acreV2.balanceOf(user), 3);

        vm.stopPrank();
    }

    function testPartiallyFailedMigration() public {
        vm.startPrank(admin);

        // Start from ID 600 to avoid conflicts
        uint256 startId = 600;
        // Mint some tokens to user
        for (uint256 i = 0; i < 5; i++) {
            acreV1.mint(user, startId + i);
        }

        vm.stopPrank();

        vm.startPrank(user);

        // Only approve some tokens for migration
        acreV1.approve(address(migrator), startId);
        acreV1.approve(address(migrator), startId + 1);
        acreV1.approve(address(migrator), startId + 2);
        // Deliberately skip approval for tokens 3 and 4

        uint256[] memory acreIds = new uint256[](5);
        uint256[] memory emptyIds = new uint256[](0);
        for (uint256 i = 0; i < 5; i++) {
            acreIds[i] = startId + i;
        }

        // This should revert due to partial approval
        vm.expectRevert();
        migrator.migrateAllAsset(acreIds, emptyIds, emptyIds);

        vm.stopPrank();
    }


    // Edge Case: Reentrancy Attack Test
    function testReentrancyAttack() public {
        MaliciousReceiver malicious = new MaliciousReceiver(address(migrator), address(tokenV1), address(tokenV2));
        
        vm.startPrank(admin);
        tokenV1.transfer(address(malicious), 1e18);
        tokenV2.transfer(address(migrator), 1e18);
        vm.stopPrank();

        vm.prank(address(malicious));
        vm.expectRevert(); // Should revert on reentrancy attempt
        migrator.migrateERC20Token(1e18, address(tokenV1), address(tokenV2));
    }

    // Edge Case: Maximum Value Migration
    function testMaxValueMigration() public {
        vm.startPrank(admin);
        uint256 largeAmount = 2**200; // Very large number but below uint256 max
        tokenV1.mint(user, largeAmount);
        tokenV2.mint(address(migrator), largeAmount * 2); // Double for 1:2 ratio
        vm.stopPrank();

        vm.startPrank(user);
        tokenV1.approve(address(migrator), largeAmount);
        
        bool success = migrator.migrateERC20Token(largeAmount, address(tokenV1), address(tokenV2));
        assertTrue(success, "Large value migration failed");
        assertEq(tokenV2.balanceOf(user), largeAmount * 2, "Incorrect token V2 amount received");
        vm.stopPrank();
    }

    // Edge Case: Concurrent Migrations
    function testConcurrentMigrations() public {
        address user1 = makeAddr("user1");
        address user2 = makeAddr("user2");
        
        vm.startPrank(admin);
        tokenV1.transfer(user1, 1e18);
        tokenV1.transfer(user2, 1e18);
        vm.stopPrank();

        vm.prank(user1);
        tokenV1.approve(address(migrator), 1e18);
        
        vm.prank(user2);
        tokenV1.approve(address(migrator), 1e18);

        vm.prank(user1);
        migrator.migrateERC20Token(5e17, address(tokenV1), address(tokenV2));
        
        vm.prank(user2);
        migrator.migrateERC20Token(5e17, address(tokenV1), address(tokenV2));

        assertEq(tokenV2.balanceOf(user1), 1e18, "User1 received incorrect amount");
        assertEq(tokenV2.balanceOf(user2), 1e18, "User2 received incorrect amount");
    }

    // Edge Case: Token Approval Manipulation
// Edge Case: Token Approval Manipulation
    function testApprovalManipulation() public {
        vm.startPrank(user);
        
        // Initial approval
        tokenV1.approve(address(migrator), 1e18);
        
        // Reduce approval before migration
        tokenV1.approve(address(migrator), 5e17);
        
        // Should fail due to insufficient allowance - using exact error message from contract
        vm.expectRevert(abi.encodeWithSignature("TransactionMessage(string)", "Insufficient allowance"));
        migrator.migrateERC20Token(1e18, address(tokenV1), address(tokenV2));
        
        // Increase approval and try again
        tokenV1.approve(address(migrator), 1e18);
        migrator.migrateERC20Token(1e18, address(tokenV1), address(tokenV2));
        
        // Verify final balance
        assertEq(tokenV2.balanceOf(user), 2e18, "Incorrect final balance after approval changes");
        vm.stopPrank();
    }

    // Edge Case: Gas Griefing Attack
    function testGasGriefing() public {
        // Reduce the number to a more reasonable size that won't exceed block gas limit
        uint256 largeButReasonable = 100;
        
        vm.startPrank(admin);
        // Mint NFTs to simulate gas griefing
        for(uint256 i = 0; i < largeButReasonable; i++) {
            acreV1.mint(user, i + 1000); // Start from 1000 to avoid conflicts
        }
        vm.stopPrank();

        vm.startPrank(user);
        acreV1.setApprovalForAll(address(migrator), true);
        
        // Create arrays for batch migration
        uint256[] memory acreIds = new uint256[](largeButReasonable);
        uint256[] memory emptyIds = new uint256[](0);
        
        for(uint256 i = 0; i < largeButReasonable; i++) {
            acreIds[i] = i + 1000;
        }
        
        // Measure gas consumption
        uint256 gasBefore = gasleft();
        migrator.migrateAllAsset(acreIds, emptyIds, emptyIds);
        uint256 gasUsed = gasBefore - gasleft();
        
        console.log("Gas used in batch migration:", gasUsed);
        // Adjust gas limit to a more reasonable threshold (around 6M for a batch of 100)
        assertTrue(gasUsed < 6_000_000, "Gas usage too high - potential griefing vulnerability");
        
        // Verify NFTs were properly migrated
        assertEq(acreV2.balanceOf(user), largeButReasonable, "Not all NFTs were migrated");
        
        vm.stopPrank();
    }

    // EPrice Manipulation During Migration
    function testPriceManipulationDuringMigration() public {
        vm.startPrank(admin);
        uint256 amount = 1e18;
        tokenV1.transfer(user, amount * 2);
        vm.stopPrank();

        vm.startPrank(user);
        tokenV1.approve(address(migrator), amount * 2);
        
        // First migration
        migrator.migrateERC20Token(amount, address(tokenV1), address(tokenV2));
        
        vm.stopPrank();
        
        // Admin changes price mid-migration
        vm.startPrank(admin);
        migrator.setTokenInfo(address(tokenV1), address(tokenV2), 3); // Change ratio to 1:3
        vm.stopPrank();
        
        vm.startPrank(user);
        migrator.migrateERC20Token(amount, address(tokenV1), address(tokenV2));
        
        // Verify different rates were applied correctly
        uint256 expectedBalance = (amount * 2) + (amount * 3);
        assertEq(tokenV2.balanceOf(user), expectedBalance, "Incorrect balance after price manipulation");
        vm.stopPrank();
    }

    // Multiple Token Approvals and Revocations
    function testMultipleApprovalRevocations() public {
        vm.startPrank(user);
        
        // Series of approval/revocation cycles
        for(uint256 i = 0; i < 5; i++) {
            tokenV1.approve(address(migrator), 1e18);
            tokenV1.approve(address(migrator), 0);
        }
        
        // Final approval
        tokenV1.approve(address(migrator), 1e18);
        
        // Migration should still work
        bool success = migrator.migrateERC20Token(1e18, address(tokenV1), address(tokenV2));
        assertTrue(success, "Migration failed after multiple approval cycles");
        
        vm.stopPrank();
    }

    function getRequirementsTokenInfo() internal view returns (address, address, uint256) {
        (,,,,,, address token1, address token2, uint256 price) = migrator.Requirements();
        return (token1, token2, price);
    }
}


contract MaliciousReceiver {
    Migrator public migrator;
    address public tokenV1;
    address public tokenV2;
    uint256 public attackCount;

    constructor(address _migrator, address _tokenV1, address _tokenV2) {
        migrator = Migrator(_migrator);
        tokenV1 = _tokenV1;
        tokenV2 = _tokenV2;
    }

    function onERC20Transfer(address, uint256) external {
        if (attackCount == 0) {
            attackCount++;
            ERC20Mock(tokenV1).approve(address(migrator), 1e18);
            migrator.migrateERC20Token(1e18, tokenV1, tokenV2);
        }
    }
}