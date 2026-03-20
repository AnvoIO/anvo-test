import { Chain } from "./chain";
import { Account } from "./account";
import { signatureProvider } from "./wallet";
import { generateTapos } from "./utils";

export class System {
  public chain: Chain;

  constructor(chain: Chain) {
    this.chain = chain;
  }

  /**
   * create blockchain acounts
   *
   * @param {string[]} accounts array of account names
   * @param {Asset} supplyAmount Optional. Amount of token supply to each account, 100 token if it missing
   * @return {Promise<Account[]>} list of account instances
   *
   * @api public
   */
  async createAccounts(
    accounts: string[],
    supplyAmount = this.chain.coreSymbol.convertAssetString(100)
  ): Promise<Account[]> {
    const requests = accounts.map((account) =>
      this.createAccount(account, supplyAmount)
    );
    return Promise.all(requests);
  }

  /**
   * create blockchain acount
   *
   * @param {string} account account name
   * @param {Asset} supplyAmount Optional. Amount of token supply to each account, 100 token if it missing
   * @return {Promise<Account>} account instances
   *
   * @api public
   */
  async createAccount(
    account: string,
    supplyAmount = this.chain.coreSymbol.convertAssetString(100),
    bytes: number = 1024 * 1024
  ): Promise<Account> {
    const sysAccount = this.chain.systemAccount;
    const tokenAccount = this.chain.systemSubAccount("token");

    let createAccountActions = [
      {
        account: sysAccount,
        name: "newaccount",
        authorization: [
          {
            actor: sysAccount,
            permission: "active",
          },
        ],
        data: {
          creator: sysAccount,
          name: account,
          owner: {
            threshold: 1,
            keys: [
              {
                key: signatureProvider.availableKeys[0],
                weight: 1,
              },
            ],
            accounts: [],
            waits: [],
          },
          active: {
            threshold: 1,
            keys: [
              {
                key: signatureProvider.availableKeys[0],
                weight: 1,
              },
            ],
            accounts: [],
            waits: [],
          },
        },
      },
    ];

    if (this.chain.systemContractEnable) {
      // @ts-ignore
      createAccountActions = createAccountActions.concat([
        {
          account: sysAccount,
          name: "buyrambytes",
          authorization: [
            {
              actor: sysAccount,
              permission: "active",
            },
          ],
          data: {
            payer: sysAccount,
            receiver: account,
            bytes,
          },
        },
        {
          account: sysAccount,
          name: "delegatebw",
          authorization: [
            {
              actor: sysAccount,
              permission: "active",
            },
          ],
          data: {
            from: sysAccount,
            receiver: account,
            stake_net_quantity: this.chain.coreSymbol.convertAssetString(10),
            stake_cpu_quantity: this.chain.coreSymbol.convertAssetString(10),
            transfer: 1,
          },
        },
      ]);
    }
    if (supplyAmount !== this.chain.coreSymbol.convertAssetString(0)) {
      createAccountActions.push({
        account: tokenAccount,
        name: "transfer",
        authorization: [
          {
            actor: sysAccount,
            permission: "active",
          },
        ],
        data: {
          // @ts-ignore
          from: sysAccount,
          to: account,
          quantity: supplyAmount,
          memo: "supply to test account",
        },
      });
    }
    await this.chain.api.transact(
      {
        actions: createAccountActions,
      },
      generateTapos()
    );
    return new Account(this.chain, account);
  }

  async fromAccount(accountName: string): Promise<Account> {
    try {
      await this.chain.rpc.get_account(accountName);
      const account = new Account(this.chain, accountName);
      const { code_hash } = await this.chain.rpc.get_code_hash(accountName);
      if (
        code_hash !==
        "0000000000000000000000000000000000000000000000000000000000000000"
      ) {
        await account.loadContract();
      }
      return account;
    } catch (e) {
      throw e;
    }
  }
}
