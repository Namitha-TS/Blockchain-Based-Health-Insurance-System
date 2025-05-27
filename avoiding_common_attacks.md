## Avoiding Common Attacks

### Insurance Claims BlockChain

#### The following measures were taken to ensure the Insurance Claims BlockChain dApp would not be susceptible to common attacks.


##### Reentrancy attack:
 - Contract state is  updated in funtions prior to any transfers or external calls

##### Integer Arithemtic Overflow
 - All mathematical calculations and decrementing or incrementing of values took this into consideration

##### TimeStamp
 - None of the functions or transactions are timestamp dependent

##### Gas Limits
 - Not susceptible or an issue as ether payout is limited

##### Forcibly Sending Ether to a Contract
 - Not susceptible or an issue as transfer can only occur to registered policy holder

##### Tx.origin
 - This was accounted for and tx.origin was not used in place of msg.sender


