Compiling 77 files with Solc 0.8.27
Solc 0.8.27 finished in 8.52s
Compiler run successful with warnings:
Warning (2018): Function state mutability can be restricted to view
  --> test/unit/v2-nft-unit-tests/ACREV2.t.sol:40:5:
   |
40 |     function testInitializationAcreV2() public {
   |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (2018): Function state mutability can be restricted to view
  --> test/unit/v2-nft-unit-tests/PLOTV2.t.sol:40:5:
   |
40 |     function testInitializationPlotV2() public {
   |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (2018): Function state mutability can be restricted to view
  --> test/unit/v2-nft-unit-tests/YARDV2.sol:40:5:
   |
40 |     function testInitializationyardV2() public {
   |     ^ (Relevant source part starts here and spans across multiple lines).

Analysing contracts...
Running tests...

Ran 3 tests for test/unit/Prlz.t.sol:przTest
[PASS] testApproveAndTransferFrom() (gas: 130565)
[PASS] testMint() (gas: 59882)
[PASS] testTransfer() (gas: 92005)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 144.20ms (2.04ms CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/ACREV2.t.sol:AcreV2Test
[PASS] testBatchCreationAcreV2() (gas: 194209)
[PASS] testBatchLifecycleAcrev2() (gas: 197400)
[PASS] testCannotCreateBatchWithExistingQuantityAcreV2() (gas: 189028)
[PASS] testCannotMintAboveMaxBuyAmountAcrev2() (gas: 227095)
[PASS] testCannotMintWhenInactiveAcrev2() (gas: 182456)
[PASS] testCannotMintZeroQuantityAcrev2() (gas: 191306)
[PASS] testFreeParticipantMintAcrev2() (gas: 303088)
[PASS] testInitializationAcreV2() (gas: 28697)
[PASS] testMintExhaustionAcrev2() (gas: 281745)
[PASS] testSetAndCollectTxFeeAcrev2() (gas: 38296)
[PASS] testSetFeeCollectorAcrev2() (gas: 23695)
[PASS] testSetPaymentTokenAcrev2() (gas: 23511)
[PASS] testSuccessfulMintAcrev2() (gas: 310002)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 629.66ms (12.50ms CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/PLOTV2.t.sol:PlotV2Test
[PASS] testBatchCreationPlotV2() (gas: 194165)
[PASS] testBatchLifecyclePlotv2() (gas: 197379)
[PASS] testCannotCreateBatchWithExistingQuantityPlotV2() (gas: 189029)
[PASS] testCannotMintAboveMaxBuyAmountPlotv2() (gas: 227095)
[PASS] testCannotMintWhenInactivePlotv2() (gas: 182411)
[PASS] testCannotMintZeroQuantityPlotv2() (gas: 191349)
[PASS] testFreeParticipantMintPlotv2() (gas: 303132)
[PASS] testInitializationPlotV2() (gas: 28740)
[PASS] testMintExhaustionPlotv2() (gas: 281813)
[PASS] testSetAndCollectTxFeePlotv2() (gas: 38296)
[PASS] testSetFeeCollectorPlotv2() (gas: 23628)
[PASS] testSetPaymentTokenPlotv2() (gas: 23534)
[PASS] testSuccessfulMintPlotv2() (gas: 310047)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 639.44ms (13.53ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/PLOTv1.t.sol:AtlPlotTest
[PASS] testMintPlot() (gas: 226396)
[PASS] testRevertIfMintingInactiveBatchPlot() (gas: 69978)
[PASS] testRevertIfNotOwnerPlot() (gas: 15224)
[PASS] testSetCurrentBatchActivePlot() (gas: 68478)
[PASS] testSetCurrentBatchPlot() (gas: 87970)
[PASS] testSetFeeCollectorRevertIfZeroAddressPlot() (gas: 14634)
[PASS] testSetFreeParticipantControllerPlot() (gas: 40927)
[PASS] testSetFreeParticipantPlot() (gas: 44469)
[PASS] testSetPaymentTokenPlot() (gas: 26541)
[PASS] testSetTxFeePlot() (gas: 37611)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 638.67ms (6.02ms CPU time)

Ran 13 tests for test/unit/v2-nft-unit-tests/YARDV2.sol:YardV2Test
[PASS] testBatchCreationyardV2() (gas: 194232)
[PASS] testBatchLifecycleyardv2() (gas: 197422)
[PASS] testCannotCreateBatchWithExistingQuantityyardV2() (gas: 189006)
[PASS] testCannotMintAboveMaxBuyAmountyardv2() (gas: 227096)
[PASS] testCannotMintWhenInactiveyardv2() (gas: 182478)
[PASS] testCannotMintZeroQuantityyardv2() (gas: 191263)
[PASS] testFreeParticipantMintyardv2() (gas: 303108)
[PASS] testInitializationyardV2() (gas: 28763)
[PASS] testMintExhaustionyardv2() (gas: 281789)
[PASS] testSetAndCollectTxFeeyardv2() (gas: 38297)
[PASS] testSetFeeCollectoryardv2() (gas: 23628)
[PASS] testSetPaymentTokenyardv2() (gas: 23599)
[PASS] testSuccessfulMintyardv2() (gas: 310068)
Suite result: ok. 13 passed; 0 failed; 0 skipped; finished in 670.00ms (20.00ms CPU time)

Ran 3 tests for test/unit/Busd.t.sol:BUSDTest
[PASS] testApproveAndTransferFrom() (gas: 130565)
[PASS] testMint() (gas: 59882)
[PASS] testTransfer() (gas: 92005)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 183.60ms (2.85ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/YARDv1.t.sol:ATLYARDTest
[PASS] testMintYard() (gas: 226350)
[PASS] testRevertIfMintingInactiveBatchYard() (gas: 70000)
[PASS] testRevertIfNotOwnerYard() (gas: 15224)
[PASS] testSetCurrentBatchActiveYard() (gas: 68544)
[PASS] testSetCurrentBatchYard() (gas: 88014)
[PASS] testSetFeeCollectorRevertIfZeroAddressYard() (gas: 14679)
[PASS] testSetFreeParticipant() (gas: 44426)
[PASS] testSetFreeParticipantController() (gas: 40928)
[PASS] testSetPaymentTokenYard() (gas: 26607)
[PASS] testSetTxFeeYard() (gas: 37652)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 646.15ms (6.38ms CPU time)

Ran 10 tests for test/unit/v1-nft-unit-tests/ACREv1.t.sol:ATLACRETest
[PASS] testMintAcre() (gas: 226462)
[PASS] testRevertIfMintingInactiveBatchAcre() (gas: 70002)
[PASS] testRevertIfNotOwnerAcre() (gas: 15269)
[PASS] testSetCurrentBatchAcre() (gas: 88059)
[PASS] testSetCurrentBatchActiveAcre() (gas: 68568)
[PASS] testSetFeeCollectorRevertIfZeroAddressAcre() (gas: 14590)
[PASS] testSetFreeParticipantAcre() (gas: 46608)
[PASS] testSetFreeParticipantControllerAcre() (gas: 40817)
[PASS] testSetPaymentTokenAcre() (gas: 26648)
[PASS] testSetTxFeeAcre() (gas: 37631)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 659.67ms (6.36ms CPU time)

Ran 9 tests for test/unit/Migrator.t.sol:MigratorTest
[PASS] testERC20Migration() (gas: 168097)
[PASS] testFailERC20MigrationInsufficientAllowance() (gas: 29480)
[PASS] testFailNFTMigrationUnapproved() (gas: 29829)
[PASS] testFailSetERC721RequirementsUnauthorized() (gas: 15563)
[PASS] testFailSetTokenInfoUnauthorized() (gas: 14624)
[PASS] testNFTMigration() (gas: 587789)
[PASS] testSetERC721Requirements() (gas: 45561)
[PASS] testSetTokenInfo() (gas: 55825)
[PASS] testTokenBReceivedIsCorrectMigrationAmount() (gas: 170713)
Suite result: ok. 9 passed; 0 failed; 0 skipped; finished in 701.23ms (17.15ms CPU time)

Ran 9 test suites in 1.52s (4.91s CPU time): 84 tests passed, 0 failed, 0 skipped (84 total tests)
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
