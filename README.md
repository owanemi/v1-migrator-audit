# v1 Migrator Audit

This repository contains a security audit of v1 migrator contracts using the Foundry testing framework. The audit includes comprehensive test coverage, gas optimization analysis, and detailed security findings.

## Prerequisites

- Foundry

## Installation

1. Install Foundry:

        curl -L https://foundry.paradigm.xyz | bash

2. after installation has been completed run foundryup

        foundryup

## Getting started
1. Clone this repo:

        git clone https://github.com/owanemi/v1-migrator-audit.git
        cd v1-migrator-audit

2. Installing dependencies
 
       forge install foundry-rs/forge-std --no-commit

3. Install latest Openzeppelin contracts

       forge install https://github.com/OpenZeppelin/openzeppelin-contracts.git --no-commit

4. Install v4.8.0 of openzeppelin upgradeable contracts, which the original v1 migrator uses

        forge install https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable.git@4.8.0 --no-commit

5. Run forge compile to make sure everything is in check
 
        forge compile

## Running tests

This will execute all tests in the project:

        forge test

To see console.logs, run the following command:

        forge test -vv

To see more detailed logs and stack traces run:

        forge test -vvvv

To run a specific test:

        forge test --match-test testName

Example:

        forge test --match-test testTokenBReceivedIsCorrectMigrationAmount -vv

The output returned will be:
```bash
$ forge test --match-test testTokenBReceivedIsCorrectMigrationAmount -vv
[⠆] Compiling...
[⠃] Compiling 1 files with Solc 0.8.27
[⠊] Solc 0.8.27 finished in 6.96s
Compiler run successful!

Ran 1 test for test/unit/Migrator.t.sol:MigratorTest
[PASS] testTokenBReceivedIsCorrectMigrationAmount() (gas: 153243)
Logs:
  initialv1Balance:  6
  initialV2Balance:  0
  finalv1balance:  0
  finalV2Balance:  12

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 2.83ms (444.76µs CPU time)

Ran 1 test suite in 9.00ms (2.83ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

To see the test coverage run:

        forge coverage
The output returned will be: 

```bash
Ran 9 test suites in 1.94s (7.01s CPU time): 84 tests passed, 0 failed, 0 skipped (84 total tests)
| File                                       | % Lines          | % Statements     | % Branches      | % Funcs         |
|--------------------------------------------|------------------|------------------|-----------------|-----------------|
| src/COA-Contracts/Busd.sol                 | 100.00% (2/2)    | 100.00% (1/1)    | 100.00% (0/0)   | 100.00% (1/1)   |
| src/COA-Contracts/Prlz.sol                 | 100.00% (2/2)    | 100.00% (1/1)    | 100.00% (0/0)   | 100.00% (1/1)   |
| src/COA-Contracts/land-nfts/ACRE.sol       | 90.24% (37/41)   | 93.33% (28/30)   | 63.16% (12/19)  | 83.33% (10/12)  |
| src/COA-Contracts/land-nfts/ERC721A.sol    | 21.48% (32/149)  | 17.16% (29/169)  | 3.33% (1/30)    | 27.27% (9/33)   |
| src/COA-Contracts/land-nfts/PLOT.sol       | 90.48% (38/42)   | 93.55% (29/31)   | 61.90% (13/21)  | 83.33% (10/12)  |
| src/COA-Contracts/land-nfts/YARD.sol       | 90.48% (38/42)   | 93.55% (29/31)   | 61.90% (13/21)  | 83.33% (10/12)  |
| src/COA-Contracts/land-nfts-v2/ACREV2.sol  | 87.50% (49/56)   | 84.75% (50/59)   | 64.29% (9/14)   | 76.92% (10/13)  |
| src/COA-Contracts/land-nfts-v2/ERC721A.sol | 17.26% (29/168)  | 13.66% (25/183)  | 3.12% (1/32)    | 19.44% (7/36)   |
| src/COA-Contracts/land-nfts-v2/PLOTV2.sol  | 87.50% (49/56)   | 84.75% (50/59)   | 64.29% (9/14)   | 76.92% (10/13)  |
| src/COA-Contracts/land-nfts-v2/YARDV2.sol  | 87.50% (49/56)   | 84.75% (50/59)   | 64.29% (9/14)   | 76.92% (10/13)  |
| src/Migrator.sol                           | 96.25% (77/80)   | 88.57% (93/105)  | 57.69% (15/26)  | 90.00% (9/10)   |
| test/unit/Migrator.t.sol                   | 75.00% (6/8)     | 85.71% (6/7)     | 100.00% (0/0)   | 66.67% (2/3)    |
| Total                                      | 58.12% (408/702) | 53.20% (391/735) | 42.93% (82/191) | 55.97% (89/159) |
```
        
## Checking gas reports:

