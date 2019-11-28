## MythX

MythX is a security analysis tool for finding vulnerabilities in smart contracts

### Truffle Security Plugin

To use MythX in truffle you can use the [truffle security plugin](https://github.com/ConsenSys/truffle-security)

Installing:

```
$ npm install -g truffle-security
```
Configuring:

Currently, the plugin must be activated on a per-project basis. If truffle-security was installed to the Truffle project root, it will try to automatically install itself to truffle-config.js. If you installed truffle-security globally, add the following to truffle-config.js in the root directory of your Truffle project to enable the plugin:

```
module.exports = {
    plugins: [ "truffle-security" ]
};
```

You will also need to create and configure a [MythX account](https://github.com/ConsenSys/truffle-security#mythx-account)

## Run examples

`npm install`

`truffle run verify`

## MythX free vs MythX Pro

Not all vulnerabilities are actually tested by the free version of MythX

If you are running the free version you will see this output when running `truffle run verify`

```
➜ truffle run verify
Welcome to MythX! You are currently running in Free mode.
```

You can view which vulnerabilities are covered by MythX on the [MythX coverage page](https://mythx.io/swc-coverage/)

## Mythril

[Mythril](https://github.com/ConsenSys/mythril) is a security analysis tool which is used as part of the MythX security analysis platform.

**Important to note that Mythril is only part of the tool set and will not give you full coverage or analysis that MythX provides**

However you can run Mythril for free and locally

Installing:

I prefer to install via docker:

```
$ docker pull mythril/myth
```

However you can see the full install documents [here](https://mythril-classic.readthedocs.io/en/master/installation.html)

To pass a file from your host machine to the dockerized Mythril, you must mount its containing folder to the container properly. For `VulnerableBank.sol` in the current working directory, do:

```
docker run -v $(pwd):/tmp mythril/myth analyze /tmp/VulnerableBank.sol
```

If your file is importing from an npm packaging like openzeppelin then you will need to modify the import so that Mythril can detect this:

Update:

```
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
```

To:

```
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
```
