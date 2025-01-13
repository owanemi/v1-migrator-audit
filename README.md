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

        
