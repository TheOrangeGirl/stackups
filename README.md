# Stackups - Your Personal Savings Tracker on the Blockchain

Stackups is a Clarity smart contract that helps you track your savings and progress towards your financial milestones.  Deposit STX, set your target amount, and let Stackups monitor your journey.

## Features

* **Deposit STX:** Securely deposit your STX into your personal savings account on the blockchain.
* **Set Milestones:** Define your savings goals by setting milestones.
* **Track Progress:** Monitor your progress towards achieving your milestones.
* **Event Emission:** Track deposit events and milestone achievements.

## How it Works

The `stackups.clar` contract utilizes Clarity's data structures and functions to manage user savings.  Here's a breakdown of the core functionality:

* **`deposit(amount uint)`:** Allows users to deposit STX into their savings.  The contract updates the user's balance and emits a `deposit` event.
* **`set-milestone(milestone uint)`:** Enables users to set a savings milestone.  The contract stores the milestone and emits a `milestone-set` event.
* **`check-progress()`:** Checks the user's current balance against their set milestone.  If the balance meets or exceeds the milestone, a `milestone-achieved` event is emitted.  The function returns the user's status (Achieved or In Progress), milestone, and current balance.

## Events

The contract emits the following events:

* **`deposit`:** Emitted when a user deposits STX.  Includes the user's principal and the deposited amount.
* **`milestone-set`:** Emitted when a user sets a new milestone.  Includes the user's principal and the milestone amount.
* **`milestone-achieved`:** Emitted when a user's balance reaches or exceeds their set milestone.  Includes the user's principal and the achieved milestone.

## Getting Started

1. Clone this repository.
2. Deploy the `stackups.clar` contract to a Stacks blockchain.
3. Interact with the contract using a Clarity-compatible wallet or tool.

## Contributing

Contributions are welcome!  Feel free to open issues and submit pull requests.
