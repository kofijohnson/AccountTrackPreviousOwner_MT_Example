# MicroTrigger Example

This repository contains an example of a Trigger development using the [MicroTrigger Framework](https://github.com/kofijohnson/Apex-MicroTrigger). In this example, we want the Account Description field to be updated every time the account owner changes with the name of the previous owner and display the text: “Previous Owner: “{PREVIOUS OWNER NAME}”.

## Create the Triggers Package Version

The Triggers Package will contain the [MicroTrigger Framework](https://github.com/kofijohnson/Apex-MicroTrigger) and the Account Apex Trigger, 
1. Clone the [MicroTrigger Framework](https://github.com/kofijohnson/Apex-MicroTrigger) repository,
2. Create a scratch org and push the MicroTrigger Framework to scratch org. Run all the test classes and confirm all the tests pass,
3. Create the Account Apex Trigger,
4. Create an Unlocked Package and a Package version.

## Deploy "Account Track Previous Owner" Example

1. Clone this repository,
2. Create a new scratch org and install the version of the Triggers Package version created earlier,
3. Push the code to the scratch org. Run all the test classes and confirm all the tests pass.
