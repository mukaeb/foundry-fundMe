-include .env 

fund:;forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

withdraw:; fund:;forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

deploy-sepolia:; forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA) --account keytest --sender 0x3191c53ec36462d8Bc5D13beE58F9Fe95779fdAe --broadcast --verify --etherscan-api-key $(ETHERSCAN) -vvvv