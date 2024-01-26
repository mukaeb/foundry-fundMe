//1- anvil أن ينشى عقود شاينلينك مزيفه لو أنا في الشبكة المحليه أو بستخدم 
//2- هو أنه يتتبع عناوين عقود شاينليك في كل الشبكات اللي حننشر فيها العقد 
// Sepolia : 0x694AA1769357215DE4FAC081bf1f309aDC325306
// Anvil: يفترض أن ينشى عقد جديد و ينشره و يرجع العنوات 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNework ;
    //decimal
    uint8 public constant DECIMAL = 8 ; 

    int256 public constant INITIAL_PRICE = 2377e8 ;    

    struct NetworkConfig {
        address priceFeed ; 
    }

    constructor(){
        if(block.chainid == 11155111){
            activeNework = getSepoliaEthConfig();
        } else if (block.chainid == 1 ){
            activeNework = getMainnetEthConfig();
        } else {
            activeNework = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        //ETH/USD pricefeed address 
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 
        });
        return sepoliaConfig ; 
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        //ETH/USD pricefeed address 
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 
        });
        return sepoliaConfig ; 
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        //ETH/USD pricefeed address 
        // إنشاء عقود شاينلك مزيفه لمغذيات الإسعار 
        // إرجاع عناوين هذه العقود 
        
        if (activeNework.priceFeed != address(0)){
            return activeNework;
        }
        
        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,INITIAL_PRICE
            );

        vm.stopBroadcast() ; 

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}