[# v1 Migrator Audit](./final-report.md)

This repository contains a security audit of v1 migrator contracts using the Foundry testing framework. The audit includes comprehensive test coverage, gas optimization analysis, and detailed security findings.
The final report is [here](./final-report.md)

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

To run gas reports:

        forge snapshot --gas-report

The expected output would be:
```bash
| src/COA-Contracts/Busd.sol:BUSD contract |                 |       |        |       |         |
|------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                          | Deployment Size |       |        |       |         |
| 1190809                                  | 5968            |       |        |       |         |
| Function Name                            | min             | avg   | median | max   | # calls |
| allowance                                | 1245            | 1245  | 1245   | 1245  | 2       |
| approve                                  | 46876           | 46876 | 46876  | 46876 | 1       |
| balanceOf                                | 850             | 850   | 850    | 850   | 5       |
| mint                                     | 68892           | 68892 | 68892  | 68892 | 3       |
| transfer                                 | 52180           | 52180 | 52180  | 52180 | 1       |
| transferFrom                             | 60306           | 60306 | 60306  | 60306 | 1       |


| src/COA-Contracts/Prlz.sol:PRLZ contract |                 |       |        |       |         |
|------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                          | Deployment Size |       |        |       |         |
| 1190809                                  | 5968            |       |        |       |         |
| Function Name                            | min             | avg   | median | max   | # calls |
| allowance                                | 1245            | 1245  | 1245   | 1245  | 2       |
| approve                                  | 46876           | 46876 | 46876  | 46876 | 1       |
| balanceOf                                | 850             | 850   | 850    | 850   | 5       |
| mint                                     | 68892           | 68892 | 68892  | 68892 | 3       |
| transfer                                 | 52180           | 52180 | 52180  | 52180 | 1       |
| transferFrom                             | 60306           | 60306 | 60306  | 60306 | 1       |


| src/COA-Contracts/land-nfts-v2/ACREV2.sol:ACREV2 contract |                 |        |        |        |         |
|-----------------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                           | Deployment Size |        |        |        |         |
| 3847379                                                   | 17649           |        |        |        |         |
| Function Name                                             | min             | avg    | median | max    | # calls |
| balanceOf                                                 | 998             | 998    | 998    | 998    | 2       |
| currentBatch                                              | 1434            | 1434   | 1434   | 1434   | 3       |
| feeCollector                                              | 552             | 1552   | 1552   | 2552   | 2       |
| grantRole                                                 | 51995           | 51995  | 51995  | 51995  | 13      |
| initialize                                                | 187977          | 187977 | 187977 | 187977 | 13      |
| maxBuyAmount                                              | 2471            | 2471   | 2471   | 2471   | 1       |
| mint                                                      | 23855           | 67488  | 30583  | 132430 | 7       |
| paymentToken                                              | 576             | 1576   | 1576   | 2576   | 2       |
| setCurrentBatch                                           | 26962           | 171879 | 192405 | 192405 | 10      |
| setCurrentBatchActive                                     | 24386           | 35342  | 35342  | 46298  | 2       |
| setFeeCollector                                           | 26673           | 26873  | 26673  | 29473  | 14      |
| setFreeParticipant                                        | 46977           | 46977  | 46977  | 46977  | 1       |
| setPaymentToken                                           | 29473           | 29473  | 29473  | 29473  | 1       |
| setTxFee                                                  | 46358           | 46358  | 46358  | 46358  | 1       |
| txFeeAmount                                               | 537             | 1537   | 1537   | 2537   | 2       |


| src/COA-Contracts/land-nfts-v2/PLOTV2.sol:PLOTV2 contract |                 |        |        |        |         |
|-----------------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                           | Deployment Size |        |        |        |         |
| 3847379                                                   | 17649           |        |        |        |         |
| Function Name                                             | min             | avg    | median | max    | # calls |
| balanceOf                                                 | 998             | 998    | 998    | 998    | 2       |
| currentBatch                                              | 1434            | 1434   | 1434   | 1434   | 3       |
| feeCollector                                              | 552             | 1552   | 1552   | 2552   | 2       |
| grantRole                                                 | 51995           | 51995  | 51995  | 51995  | 13      |
| initialize                                                | 187977          | 187977 | 187977 | 187977 | 13      |
| maxBuyAmount                                              | 2471            | 2471   | 2471   | 2471   | 1       |
| mint                                                      | 23855           | 67488  | 30583  | 132430 | 7       |
| paymentToken                                              | 576             | 1576   | 1576   | 2576   | 2       |
| setCurrentBatch                                           | 26962           | 171879 | 192405 | 192405 | 10      |
| setCurrentBatchActive                                     | 24386           | 35342  | 35342  | 46298  | 2       |
| setFeeCollector                                           | 26673           | 26873  | 26673  | 29473  | 14      |
| setFreeParticipant                                        | 46977           | 46977  | 46977  | 46977  | 1       |
| setPaymentToken                                           | 29473           | 29473  | 29473  | 29473  | 1       |
| setTxFee                                                  | 46358           | 46358  | 46358  | 46358  | 1       |
| txFeeAmount                                               | 537             | 1537   | 1537   | 2537   | 2       |


| src/COA-Contracts/land-nfts-v2/YARDV2.sol:YARDV2 contract |                 |        |        |        |         |
|-----------------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                           | Deployment Size |        |        |        |         |
| 3847367                                                   | 17649           |        |        |        |         |
| Function Name                                             | min             | avg    | median | max    | # calls |
| balanceOf                                                 | 998             | 998    | 998    | 998    | 2       |
| currentBatch                                              | 1434            | 1434   | 1434   | 1434   | 3       |
| feeCollector                                              | 552             | 1552   | 1552   | 2552   | 2       |
| grantRole                                                 | 51995           | 51995  | 51995  | 51995  | 13      |
| initialize                                                | 187977          | 187977 | 187977 | 187977 | 13      |
| maxBuyAmount                                              | 2471            | 2471   | 2471   | 2471   | 1       |
| mint                                                      | 23855           | 67488  | 30583  | 132430 | 7       |
| paymentToken                                              | 576             | 1576   | 1576   | 2576   | 2       |
| setCurrentBatch                                           | 26962           | 171879 | 192405 | 192405 | 10      |
| setCurrentBatchActive                                     | 24386           | 35342  | 35342  | 46298  | 2       |
| setFeeCollector                                           | 26673           | 26873  | 26673  | 29473  | 14      |
| setFreeParticipant                                        | 46977           | 46977  | 46977  | 46977  | 1       |
| setPaymentToken                                           | 29473           | 29473  | 29473  | 29473  | 1       |
| setTxFee                                                  | 46358           | 46358  | 46358  | 46358  | 1       |
| txFeeAmount                                               | 537             | 1537   | 1537   | 2537   | 2       |


| src/COA-Contracts/land-nfts/ACRE.sol:ATLACRE contract |                 |       |        |        |
    |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |
    |
| 3358218                                               | 15852           |       |        |        |
    |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 990             | 990   | 990    | 990    | 2
    |
| _paymentToken                                         | 575             | 575   | 575    | 575    | 1
    |
| _txFeeAmount                                          | 515             | 515   | 515    | 515    | 1
    |
| balanceOf                                             | 955             | 955   | 955    | 955    | 1
    |
| freeParticipantControllers                            | 879             | 879   | 879    | 879    | 1
    |
| freeParticipants                                      | 879             | 879   | 879    | 879    | 1
    |
| mint                                                  | 28485           | 83476 | 83476  | 138467 | 2
    |
| setCurrentBatch                                       | 24825           | 76487 | 94381  | 94381  | 5
    |
| setCurrentBatchActive                                 | 24222           | 24222 | 24222  | 24222  | 1
    |
| setFeeCollector                                       | 24263           | 26284 | 26487  | 26487  | 11
    |
| setFreeParticipant                                    | 48965           | 48965 | 48965  | 48965  | 1
    |
| setFreeParticipantController                          | 46756           | 46756 | 46756  | 46756  | 1
    |
| setPaymentToken                                       | 29353           | 29353 | 29353  | 29353  | 1
    |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1
    |
| totalSupply                                           | 2688            | 2688  | 2688   | 2688   | 1
    |


| src/COA-Contracts/land-nfts/PLOT.sol:ATLPLOT contract |                 |       |        |        |
    |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |
    |
| 3328417                                               | 15928           |       |        |        |
    |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 968             | 968   | 968    | 968    | 2
    |
| balanceOf                                             | 976             | 976   | 976    | 976    | 1
    |
| freeParticipantControllers                            | 946             | 946   | 946    | 946    | 1
    |
| freeParticipants                                      | 923             | 923   | 923    | 923    | 1
    |
| mint                                                  | 28463           | 83454 | 83454  | 138445 | 2
    |
| paymentToken                                          | 554             | 554   | 554    | 554    | 1
    |
| setCurrentBatch                                       | 24803           | 76465 | 94359  | 94359  | 5
    |
| setCurrentBatchActive                                 | 24178           | 24178 | 24178  | 24178  | 1
    |
| setFeeCollector                                       | 24329           | 26350 | 26553  | 26553  | 11
    |
| setFreeParticipant                                    | 46716           | 46716 | 46716  | 46716  | 1
    |
| setFreeParticipantController                          | 46823           | 46823 | 46823  | 46823  | 1
    |
| setPaymentToken                                       | 29287           | 29287 | 29287  | 29287  | 1
    |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1
    |
| totalSupply                                           | 2644            | 2644  | 2644   | 2644   | 1
    |
| txFeeAmount                                           | 515             | 515   | 515    | 515    | 1
    |


| src/COA-Contracts/land-nfts/YARD.sol:ATLYARD contract |                 |       |        |        |
    |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |
    |
| 3328405                                               | 15928           |       |        |        |
    |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 968             | 968   | 968    | 968    | 2
    |
| balanceOf                                             | 976             | 976   | 976    | 976    | 1
    |
| freeParticipantControllers                            | 946             | 946   | 946    | 946    | 1
    |
| freeParticipants                                      | 923             | 923   | 923    | 923    | 1
    |
| mint                                                  | 28463           | 83454 | 83454  | 138445 | 2
    |
| paymentToken                                          | 554             | 554   | 554    | 554    | 1
    |
| setCurrentBatch                                       | 24803           | 76465 | 94359  | 94359  | 5
    |
| setCurrentBatchActive                                 | 24178           | 24178 | 24178  | 24178  | 1
    |
| setFeeCollector                                       | 24329           | 26350 | 26553  | 26553  | 11
    |
| setFreeParticipant                                    | 46716           | 46716 | 46716  | 46716  | 1
    |
| setFreeParticipantController                          | 46823           | 46823 | 46823  | 46823  | 1
    |
| setPaymentToken                                       | 29287           | 29287 | 29287  | 29287  | 1
    |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1
    |
| totalSupply                                           | 2644            | 2644  | 2644   | 2644   | 1
    |
| txFeeAmount                                           | 515             | 515   | 515    | 515    | 1
    |


| src/Migrator.sol:Migrator contract |                 |        |        |        |         |
|------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                    | Deployment Size |        |        |        |         |
| 2919057                            | 13335           |        |        |        |         |
| Function Name                      | min             | avg    | median | max    | # calls |
| Requirements                       | 14879           | 16879  | 16879  | 18879  | 2       |
| grantRole                          | 51972           | 51972  | 51972  | 51972  | 9       |
| initialize                         | 92697           | 92697  | 92697  | 92697  | 9       |
| migrateAllAsset                    | 40007           | 272396 | 272396 | 504786 | 2       |
| migrateERC20Token                  | 36291           | 111696 | 149399 | 149399 | 3       |
| setERC721Requirements              | 26116           | 136734 | 160712 | 160712 | 11      |
| setTokenInfo                       | 25079           | 69219  | 77053  | 77053  | 11      |


| test/unit/Migrator.t.sol:CollectibleMock contract |                 |       |        |       |         ||---------------------------------------------------|-----------------|-------|--------|-------|---------|| Deployment Cost                                   | Deployment Size |       |        |       |         || 2405909                                           | 12104           |       |        |       |         || Function Name                                     | min             | avg   | median | max   |  calls || balanceOf                                         | 952             | 952   | 952    | 952   | 3       || isApprovedForAll                                  | 1308            | 2908  | 3308   | 3308  | 5       || mint                                              | 52414           | 65230 | 69502  | 69502 | 36      || ownerOf                                           | 985             | 2096  | 2985   | 2985  | 9       || setApprovalForAll                                 | 46674           | 46674 | 46674  | 46674 | 3       |




Ran 9 test suites in 3.55s (13.79s CPU time): 84 tests passed, 0 failed, 0 skipped (84 total tests)
```
