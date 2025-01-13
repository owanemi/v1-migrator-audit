No files changed, compilation skipped

Ran 3 tests for test/unit/Busd.t.sol:BUSDTest
[PASS] testApproveAndTransferFrom() (gas: 205453)
[PASS] testMint() (gas: 81526)
[PASS] testTransfer() (gas: 140093)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 721.25ms (337.14ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/ACREv1.t.sol:ATLACRETest
[PASS] testMintAcre() (gas: 318622)
Logs:
  Gas used for minting: 145001

[PASS] testRevertIfMintingInactiveBatchAcre() (gas: 118678)
[PASS] testRevertIfNotOwnerAcre() (gas: 36753)
[PASS] testSetCurrentBatchAcre() (gas: 109543)
[PASS] testSetCurrentBatchActiveAcre() (gas: 128344)
[PASS] testSetFeeCollectorRevertIfZeroAddressAcre() (gas: 35782)
[PASS] testSetFreeParticipantAcre() (gas: 68180)
Logs:
  Gas used for setFreeParticipant: 56431

[PASS] testSetFreeParticipantControllerAcre() (gas: 62389)
[PASS] testSetPaymentTokenAcre() (gas: 48080)
Logs:
  Gas used for setPaymentToken: 34576

[PASS] testSetTxFeeAcre() (gas: 58835)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 798.38ms (626.29ms CPU time)

Ran 9 tests for test/unit/Migrator.t.sol:MigratorTest
[PASS] testERC20Migration() (gas: 235853)
[PASS] testFailERC20MigrationInsufficientAllowance() (gas: 51420)
[PASS] testFailNFTMigrationUnapproved() (gas: 51837)
[PASS] testFailSetERC721RequirementsUnauthorized() (gas: 37407)
[PASS] testFailSetTokenInfoUnauthorized() (gas: 36108)
[PASS] testNFTMigration() (gas: 614333)
[PASS] testSetERC721Requirements() (gas: 67633)
[PASS] testSetTokenInfo() (gas: 77765)
[PASS] testTokenBReceivedIsCorrectMigrationAmount() (gas: 238325)
Logs:
  initialv1Balance:  1000000000000000000000
  initialV2Balance:  0
  finalv1balance:  999999999999999999994
  finalV2Balance:  12

Suite result: ok. 9 passed; 0 failed; 0 skipped; finished in 1.71s (653.75ms CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/PLOTV2.t.sol:PlotV2Test
[PASS] testBatchCreationPlotV2() (gas: 215709)
[PASS] testBatchLifecyclePlotv2() (gas: 282419)
[PASS] testCannotCreateBatchWithExistingQuantityPlotV2() (gas: 236117)
[PASS] testCannotMintAboveMaxBuyAmountPlotv2() (gas: 295487)
[PASS] testCannotMintWhenInactivePlotv2() (gas: 250779)
[PASS] testCannotMintZeroQuantityPlotv2() (gas: 238085)
[PASS] testFreeParticipantMintPlotv2() (gas: 377752)
[PASS] testInitializationPlotV2() (gas: 28740)
[PASS] testMintExhaustionPlotv2() (gas: 405609)
[PASS] testSetAndCollectTxFeePlotv2() (gas: 59560)
[PASS] testSetFeeCollectorPlotv2() (gas: 45060)
[PASS] testSetPaymentTokenPlotv2() (gas: 44966)
[PASS] testSuccessfulMintPlotv2() (gas: 402339)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 1.93s (1.21s CPU time)

Ran 3 tests for test/unit/Prlz.t.sol:przTest
[PASS] testApproveAndTransferFrom() (gas: 205453)
[PASS] testMint() (gas: 81526)
[PASS] testTransfer() (gas: 140093)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 317.50ms (273.00ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/PLOTv1.t.sol:AtlPlotTest
[PASS] testMintPlot() (gas: 318556)
Logs:
  Gas used for minting: 144979

[PASS] testRevertIfMintingInactiveBatchPlot() (gas: 118654)
[PASS] testRevertIfNotOwnerPlot() (gas: 36708)
[PASS] testSetCurrentBatchActivePlot() (gas: 128254)
[PASS] testSetCurrentBatchPlot() (gas: 109454)
[PASS] testSetFeeCollectorRevertIfZeroAddressPlot() (gas: 35826)
[PASS] testSetFreeParticipantControllerPlot() (gas: 62499)
[PASS] testSetFreeParticipantPlot() (gas: 66041)
Logs:
  Gas used for setFreeParticipant: 54182

[PASS] testSetPaymentTokenPlot() (gas: 47973)
Logs:
  Gas used for setPaymentToken: 34510

[PASS] testSetTxFeePlot() (gas: 58815)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 567.89ms (608.24ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/YARDv1.t.sol:ATLYARDTest
[PASS] testMintYard() (gas: 318510)
Logs:
  Gas used for minting: 144979

[PASS] testRevertIfMintingInactiveBatchYard() (gas: 118676)
[PASS] testRevertIfNotOwnerYard() (gas: 36708)
[PASS] testSetCurrentBatchActiveYard() (gas: 128320)
[PASS] testSetCurrentBatchYard() (gas: 109498)
[PASS] testSetFeeCollectorRevertIfZeroAddressYard() (gas: 35871)
[PASS] testSetFreeParticipant() (gas: 65998)
Logs:
  Gas used for setFreeParticipant: 54182

[PASS] testSetFreeParticipantController() (gas: 62500)
[PASS] testSetPaymentTokenYard() (gas: 48039)
Logs:
  Gas used for setPaymentToken: 34510

[PASS] testSetTxFeeYard() (gas: 58856)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 785.72ms (613.17ms CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/YARDV2.sol:YardV2Test
[PASS] testBatchCreationyardV2() (gas: 215776)
[PASS] testBatchLifecycleyardv2() (gas: 282462)
[PASS] testCannotCreateBatchWithExistingQuantityyardV2() (gas: 236094)
[PASS] testCannotMintAboveMaxBuyAmountyardv2() (gas: 295488)
[PASS] testCannotMintWhenInactiveyardv2() (gas: 250846)
[PASS] testCannotMintZeroQuantityyardv2() (gas: 237999)
[PASS] testFreeParticipantMintyardv2() (gas: 377728)
[PASS] testInitializationyardV2() (gas: 28763)
[PASS] testMintExhaustionyardv2() (gas: 405585)
[PASS] testSetAndCollectTxFeeyardv2() (gas: 59561)
[PASS] testSetFeeCollectoryardv2() (gas: 45060)
[PASS] testSetPaymentTokenyardv2() (gas: 45031)
[PASS] testSuccessfulMintyardv2() (gas: 402360)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 845.48ms (1.14s CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/ACREV2.t.sol:AcreV2Test
[PASS] testBatchCreationAcreV2() (gas: 215753)
[PASS] testBatchLifecycleAcrev2() (gas: 282440)
[PASS] testCannotCreateBatchWithExistingQuantityAcreV2() (gas: 236116)
[PASS] testCannotMintAboveMaxBuyAmountAcrev2() (gas: 295487)
[PASS] testCannotMintWhenInactiveAcrev2() (gas: 250824)
[PASS] testCannotMintZeroQuantityAcrev2() (gas: 238042)
[PASS] testFreeParticipantMintAcrev2() (gas: 377708)
[PASS] testInitializationAcreV2() (gas: 28697)
[PASS] testMintExhaustionAcrev2() (gas: 405541)
[PASS] testSetAndCollectTxFeeAcrev2() (gas: 59560)
[PASS] testSetFeeCollectorAcrev2() (gas: 45127)
[PASS] testSetPaymentTokenAcrev2() (gas: 44943)
[PASS] testSuccessfulMintAcrev2() (gas: 402294)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 2.71s (1.22s CPU time)
| lib/openzeppelin-contracts/contracts/mocks/ERC20Mock.sol:ERC20Mock contract |                 |       |        |       |         |
|-----------------------------------------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                                                             | Deployment Size |       |        |       |         |
| 1458509                                                                     | 8277            |       |        |       |         |
| Function Name                                                               | min             | avg   | median | max   | # calls |
| allowance                                                                   | 3223            | 3223  | 3223   | 3223  | 3       |
| approve                                                                     | 46827           | 46879 | 46899  | 46899 | 17      |
| balanceOf                                                                   | 895             | 2154  | 2895   | 2895  | 27      |
| mint                                                                        | 51755           | 51798 | 51815  | 51815 | 108     |
| transfer                                                                    | 52158           | 52164 | 52164  | 52170 | 18      |


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


| src/COA-Contracts/land-nfts/ACRE.sol:ATLACRE contract |                 |       |        |        |         |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |         |
| 3358218                                               | 15852           |       |        |        |         |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 990             | 990   | 990    | 990    | 2       |
| _paymentToken                                         | 575             | 575   | 575    | 575    | 1       |
| _txFeeAmount                                          | 515             | 515   | 515    | 515    | 1       |
| balanceOf                                             | 955             | 955   | 955    | 955    | 1       |
| freeParticipantControllers                            | 879             | 879   | 879    | 879    | 1       |
| freeParticipants                                      | 879             | 879   | 879    | 879    | 1       |
| mint                                                  | 28485           | 83476 | 83476  | 138467 | 2       |
| setCurrentBatch                                       | 24825           | 76487 | 94381  | 94381  | 5       |
| setCurrentBatchActive                                 | 24222           | 24222 | 24222  | 24222  | 1       |
| setFeeCollector                                       | 24263           | 26284 | 26487  | 26487  | 11      |
| setFreeParticipant                                    | 48965           | 48965 | 48965  | 48965  | 1       |
| setFreeParticipantController                          | 46756           | 46756 | 46756  | 46756  | 1       |
| setPaymentToken                                       | 29353           | 29353 | 29353  | 29353  | 1       |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1       |
| totalSupply                                           | 2688            | 2688  | 2688   | 2688   | 1       |


| src/COA-Contracts/land-nfts/PLOT.sol:ATLPLOT contract |                 |       |        |        |         |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |         |
| 3328417                                               | 15928           |       |        |        |         |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 968             | 968   | 968    | 968    | 2       |
| balanceOf                                             | 976             | 976   | 976    | 976    | 1       |
| freeParticipantControllers                            | 946             | 946   | 946    | 946    | 1       |
| freeParticipants                                      | 923             | 923   | 923    | 923    | 1       |
| mint                                                  | 28463           | 83454 | 83454  | 138445 | 2       |
| paymentToken                                          | 554             | 554   | 554    | 554    | 1       |
| setCurrentBatch                                       | 24803           | 76465 | 94359  | 94359  | 5       |
| setCurrentBatchActive                                 | 24178           | 24178 | 24178  | 24178  | 1       |
| setFeeCollector                                       | 24329           | 26350 | 26553  | 26553  | 11      |
| setFreeParticipant                                    | 46716           | 46716 | 46716  | 46716  | 1       |
| setFreeParticipantController                          | 46823           | 46823 | 46823  | 46823  | 1       |
| setPaymentToken                                       | 29287           | 29287 | 29287  | 29287  | 1       |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1       |
| totalSupply                                           | 2644            | 2644  | 2644   | 2644   | 1       |
| txFeeAmount                                           | 515             | 515   | 515    | 515    | 1       |


| src/COA-Contracts/land-nfts/YARD.sol:ATLYARD contract |                 |       |        |        |         |
|-------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                       | Deployment Size |       |        |        |         |
| 3328405                                               | 15928           |       |        |        |         |
| Function Name                                         | min             | avg   | median | max    | # calls |
| _currentBatch                                         | 968             | 968   | 968    | 968    | 2       |
| balanceOf                                             | 976             | 976   | 976    | 976    | 1       |
| freeParticipantControllers                            | 946             | 946   | 946    | 946    | 1       |
| freeParticipants                                      | 923             | 923   | 923    | 923    | 1       |
| mint                                                  | 28463           | 83454 | 83454  | 138445 | 2       |
| paymentToken                                          | 554             | 554   | 554    | 554    | 1       |
| setCurrentBatch                                       | 24803           | 76465 | 94359  | 94359  | 5       |
| setCurrentBatchActive                                 | 24178           | 24178 | 24178  | 24178  | 1       |
| setFeeCollector                                       | 24329           | 26350 | 26553  | 26553  | 11      |
| setFreeParticipant                                    | 46716           | 46716 | 46716  | 46716  | 1       |
| setFreeParticipantController                          | 46823           | 46823 | 46823  | 46823  | 1       |
| setPaymentToken                                       | 29287           | 29287 | 29287  | 29287  | 1       |
| setTxFee                                              | 46090           | 46090 | 46090  | 46090  | 1       |
| totalSupply                                           | 2644            | 2644  | 2644   | 2644   | 1       |
| txFeeAmount                                           | 515             | 515   | 515    | 515    | 1       |


| src/Migrator.sol:Migrator contract |                 |        |        |        |         |
|------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                    | Deployment Size |        |        |        |         |
| 2919057                            | 13335           |        |        |        |         |
| Function Name                      | min             | avg    | median | max    | # calls |
| Requirements                       | 14879           | 16879  | 16879  | 18879  | 2       |
| grantRole                          | 51972           | 51972  | 51972  | 51972  | 9       |
| initialize                         | 92697           | 92697  | 92697  | 92697  | 9       |
| migrateAllAsset                    | 40007           | 272396 | 272396 | 504786 | 2       |
| migrateERC20Token                  | 36291           | 114880 | 154139 | 154211 | 3       |
| setERC721Requirements              | 26116           | 136734 | 160712 | 160712 | 11      |
| setTokenInfo                       | 25079           | 69219  | 77053  | 77053  | 11      |


| test/unit/Migrator.t.sol:CollectibleMock contract |                 |       |        |       |         |
|---------------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                                   | Deployment Size |       |        |       |         |
| 2405909                                           | 12104           |       |        |       |         |
| Function Name                                     | min             | avg   | median | max   | # calls |
| balanceOf                                         | 952             | 952   | 952    | 952   | 3       |
| isApprovedForAll                                  | 1308            | 2908  | 3308   | 3308  | 5       |
| mint                                              | 52414           | 65230 | 69502  | 69502 | 36      |
| ownerOf                                           | 985             | 2096  | 2985   | 2985  | 9       |
| setApprovalForAll                                 | 46674           | 46674 | 46674  | 46674 | 3       |




Ran 9 test suites in 2.73s (10.39s CPU time): 84 tests passed, 0 failed, 0 skipped (84 total tests)
