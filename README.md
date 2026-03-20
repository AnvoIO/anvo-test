# Welcome to anvo-test

anvo-test is an open-source Javascript-based smart-contract testing framework for [Anvo Core](https://github.com/Anvo-Network/core) blockchains.

anvo-test gives you the ability to dockerize an Anvo Core node. This allows a developer to host it on any system that supports [Docker](https://docs.docker.com). Using anvo-test, developers can simplify testing of smart contracts and automate things like table seeding, account creation, and other initialisation tasks that are required before running complex test scenarios.

The framework supports multiple chain configurations — ANVO is the first chain configured, and additional chains that adopt Anvo Core can be added easily.

#### Noteworthy Features

- Ability to run tests in parallel
- Supports ARM64 and AMD64 architectures (Ubuntu 24.04 LTS)
- Ability to insert/modify/erase data for each table
- Update the chain time to fast-forward the chain and allow testing future states
- Multi-chain extensible architecture

## Quick start

### Installation

Refer to [an example project](example)

```bash
npm install --save-dev @anvo-network/anvo-test
```

#### Jest
Install `jest`
```
npm install --save-dev jest@^28.1.3
```
Config `jest`: Create jest.config.js and add the following:

```
module.exports = {
  // transform: { "^.+\\.(ts|tsx)$": "ts-jest" },
  testEnvironment: "node",
  testTimeout: 120 * 1e3,
};
```

#### Docker

To install docker please refer [here](https://docs.docker.com/engine/install/)

### Run
Update test command in package.json

```
"test": "jest"
```

Run

```
npm run test
```

### Usage
```
const { Chain } = require("@anvo-network/anvo-test");
const { expectAction } = require("@anvo-network/anvo-test");
```
**Api** and **JsonRpc** from **eosjs** are available through the **[Chain](docs/api/chain.md)** class

```javascript
// Setup an ANVO test chain
const chain = await Chain.setupChain("ANVO");

// Run your tests...

// Clean up
await chain.clear();
```

* [Using anvo-test to write contract tests](docs/tutorial/usage.md)

## anvo-test API
### Classes

**Public**

* [Account](docs/api/account.md)
* [Chain](docs/api/chain.md)
* [Contract](docs/api/contract.md)
* [Table](docs/api/table.md)
* [Time](docs/api/time.md)

**Internal**

* [Asset](docs/api/asset.md)
* [Symbol](docs/api/symbol.md)
* [System](docs/api/system.md)


### Functions

**Public**

* [Assertion](docs/api/assertion.md)
* [Wallet](docs/api/wallet.md)

## Adding New Chain Configurations

To add support for a new chain:

1. Create a deploy script: `docker/scripts/deploy_system_contract_{chain}.sh`
2. Add contract artifacts: `docker/contracts/{chain}/`
3. Register the chain in `src/chain.ts` (`validChainNames`, `getChainTokenDecimal`, `getSystemAccountPrefix`)

## Licence

This code is provided as is, under [MIT Licence](LICENSE).
