// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { Migrator } from "src/Migrator.sol";
import { ERC20Mock } from "lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol";
import { ERC721Mock } from "lib/openzeppelin-contracts/contracts/mocks/ERC721Mock.sol";

interface IMintable {
    function mintAsFreeMinter(uint256 quantity) external;
}

// Extend ERC721Mock to add mintAsFreeMinter functionality
contract CollectibleMock is ERC721Mock, IMintable {
    uint256 private _tokenIdCounter;

    constructor(string memory name, string memory symbol) 
        ERC721Mock(name, symbol) {}

    function mintAsFreeMinter(uint256 quantity) external {
        for(uint i = 0; i < quantity; ++i) {
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

    event TokenMigrationCompleted(
        address indexed user,
        address indexed token1,
        address indexed token2,
        uint amount1,
        uint amount2,
        uint date
    );

    event NFTMigrationCompleted(
        address indexed user,
        address indexed nft1,
        address indexed nft2,
        uint oldId,
        uint newId,
        uint date
    );

    function setUp() public {
        vm.startPrank(admin);
        
        // Deploy tokens
        tokenV1 = new ERC20Mock("TokenV1", "TV1", admin, 1e24);
        tokenV2 = new ERC20Mock("TokenV2", "TV2", admin, 1e24);
        
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
            address(acreV1),
            address(yardV1),
            address(plotV1),
            address(acreV2),
            address(yardV2),
            address(plotV2)
        );

        // Fund migrator with V2 tokens
        tokenV2.transfer(address(migrator), 100000 * 10**18);

        // Setup user with V1 assets
        tokenV1.transfer(user, 6 * 10**18);
        
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
        
        uint migrationAmount = 6 * 10**18;
        uint initialV1Balance = tokenV1.balanceOf(user);
        uint initialV2Balance = tokenV2.balanceOf(user);
        
        tokenV1.approve(address(migrator), migrationAmount);
        
        vm.expectEmit(true, true, true, true);
        emit TokenMigrationCompleted(
            user,
            address(tokenV1),
            address(tokenV2),
            migrationAmount,
            migrationAmount * 2,
            block.timestamp
        );
        
        migrator.migrateERC20Token(
            migrationAmount,
            address(tokenV1),
            address(tokenV2)
        );
        
        assertEq(tokenV1.balanceOf(user), initialV1Balance - migrationAmount);
        assertEq(tokenV2.balanceOf(user), initialV2Balance + (migrationAmount * 2));
        
        vm.stopPrank();
    }

    function testTokenBReceivedIsCorrectMigrationAmount() public { 
        vm.startPrank(user); 
         
        uint initialV1Balance = tokenV1.balanceOf(user); 
        uint initialV2Balance = tokenV2.balanceOf(user); 
 
        console.log("initialv1Balance: ", initialV1Balance/ 10**18); 
        console.log("initialV2Balance: ", initialV2Balance/10**18); 
        uint migrationAmount = 6 * 10**18; // Migrate 6 tokens 
         
        // approve migrator to spend tokens 
        tokenV1.approve(address(migrator), migrationAmount); 
         
        // Perform migration 
        migrator.migrateERC20Token( 
            migrationAmount, 
            address(tokenV1), 
            address(tokenV2) 
        ); 
         
        // Check final balances 
        uint finalV1Balance = tokenV1.balanceOf(user); 
        uint finalV2Balance = tokenV2.balanceOf(user); 
        console.log("finalv1balance: ", finalV1Balance / 10**18); 
        console.log("finalV2Balance: ", finalV2Balance / 10**18); 
         
        // Calculate expected amounts 
        uint expectedV1Decrease = migrationAmount; 
        uint expectedV2Increase = migrationAmount * 2; // Should get 2x tokens due to price=2 
         
        // Verify V1 token decrease is correct 
        assertEq( 
            initialV1Balance - finalV1Balance, 
            expectedV1Decrease, 
            "V1 token decrease incorrect" 
        ); 
         
        // This assertion will fail because of the bug 
        // User receives migrationAmount instead of migrationAmount * 2 
        assertEq( 
            finalV2Balance - initialV2Balance, 
            expectedV2Increase, 
            "V2 token increase incorrect - Bug detected!" 
        ); 
        vm.stopPrank(); 
    } 

    function testFailERC20MigrationInsufficientAllowance() public {
        vm.startPrank(user);
        migrator.migrateERC20Token(100, address(tokenV1), address(tokenV2));
        vm.stopPrank();
    }


    function testFailNFTMigrationUnapproved() public {
        vm.startPrank(user);
        
        uint[] memory acreIds = new uint[](1);
        acreIds[0] = 0;
        
        uint[] memory emptyIds = new uint[](0);
        
        // Don't approve migrator
        migrator.migrateAllAsset(acreIds, emptyIds, emptyIds);
        
        vm.stopPrank();
    }

    function testNFTMigration() public {
        vm.startPrank(user);
        
        uint[] memory acreIds = new uint[](2);
        acreIds[0] = 0;
        acreIds[1] = 1;
        
        uint[] memory plotIds = new uint[](1);
        plotIds[0] = 0;
        
        uint[] memory yardIds = new uint[](1);
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
        uint newPrice = 3;
        
        migrator.setTokenInfo(newToken1, newToken2, newPrice);
        
        (address configToken1, address configToken2, uint configPrice) = getRequirementsTokenInfo();
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
        migrator.setERC721Requirements(
            newAcre,
            address(0),
            address(0),
            address(0),
            address(0),
            address(0)
        );
        
        (address configAcre,,,,,,,,) = migrator.Requirements();
        assertEq(configAcre, newAcre);
        
        vm.stopPrank();
    }

    function testFailSetERC721RequirementsUnauthorized() public {
        vm.prank(user);
        migrator.setERC721Requirements(
            address(1),
            address(0),
            address(0),
            address(0),
            address(0),
            address(0)
        );
    }

    // Helper functions
    function getRequirementsTokenInfo() internal view returns (address, address, uint) {
        (,,,,,, address token1, address token2, uint price) = migrator.Requirements();
        return (token1, token2, price);
    }
}