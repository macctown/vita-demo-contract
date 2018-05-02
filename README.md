# vita-demo-contract

This is the smart contract codebase for vitaData demo (POC). It implements all the basic functions that related to tokens, device and data. Currently it has no encryption in this version.

### Development Setup

#### IDE: VS Code 

Extensions: 
+ Solidity ext
+ editorconfig ext


#### Truffle

```
npm install -g truffle
```

#### Solium

```
npm install -g solium
```

Currently, VSCode-solidity doesn't support .soliumrc.json, we can setup vscode settings same as .soliumrc.json:

```
"solidity.linter": "solium",
"solidity.soliumRules": {
"quotes": ["error", "double"],
"indentation": ["error", 4],
"no-experimental": "off"
}
```

