// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address public USER = makeAddr("user");
    uint256 public STARTING_BALANCE = 10 ether ; 
    uint256 public SEND_VALUE = 0.1 ether ; 
    uint256 public GAS_PRICE = 1 ; 

    //fundme نحن -> عقد الإختبار -> عقد الإختبار بينشر
    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); 
    }

    function testMinValueUSDisFiveDollar() public {
        assertEq(fundMe.MIN_VALUE_USD(), 5e18);
    }

    function testOwnerIsMessageSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testAmountFoundedIsNotEnough() public { 
        vm.expectRevert(); // السطر التالي لازم يفشل 
        fundMe.fundMe();
    }

    function testFundUpdateFundsDataStructure() public {
        vm.prank(USER); 
        fundMe.fundMe{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);

    }

    modifier funded() {
        vm.prank(USER); 
        fundMe.fundMe{value: SEND_VALUE}();
        _;
    }

    function testAddFunderToArrayOfFunders() public funded{
        address funder = fundMe.getFunders(0);
        assertEq(funder, USER) ; 
    }
    
    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithAsignalFouder() public funded{
        //arrange  الترتيب 
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance; 

        //act إجراء الفعل 
        // uint256 gasStart = gasleft(); 
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; 

        // console.log(gasUsed); 

        //assert تاكيدات الفعل 
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endinggOwnerBalance = fundMe.getOwner().balance; 
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance+startingFundMeBalance, endinggOwnerBalance); 



    }

    function testWithdrawWithMultipleFounders() public funded {
        // arrange الترتيب
        uint160 numberOfFunders = 20;
        uint160 startingFundersIndex = 1 ;

        for(uint160 i = startingFundersIndex; i<numberOfFunders ; i++){
            // prank. deal 
            hoax(address(i), STARTING_BALANCE); 
            fundMe.fundMe{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // act إجراء فعل 
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // assert تاكيدات هذا الفعل 
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endinggOwnerBalance = fundMe.getOwner().balance; 
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance+startingFundMeBalance, endinggOwnerBalance); 
        
    }

    function testCheapWithdrawWithMultipleFounders() public funded {
        // arrange الترتيب
        uint160 numberOfFunders = 20;
        uint160 startingFundersIndex = 1 ;

        for(uint160 i = startingFundersIndex; i<numberOfFunders ; i++){
            // prank. deal 
            hoax(address(i), STARTING_BALANCE); 
            fundMe.fundMe{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // act إجراء فعل 
        vm.startPrank(fundMe.getOwner());
        fundMe.cheapWithdraw();
        vm.stopPrank();

        // assert تاكيدات هذا الفعل 
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endinggOwnerBalance = fundMe.getOwner().balance; 
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance+startingFundMeBalance, endinggOwnerBalance); 
        
    }


    
}













// Unit الوحدة
// يركز على أصغر جزء من الكود، مثل الوظائف و المتغيرات

// Integration  التكامل
// بعد اختبار الوحدات بشكل فردي، يتم اختبار التكامل لضمان أن هذه الوحدات تعمل معاً بشكل صحيح

// Forked المفرع
// يشمل تشغيل الاختبارات في بيئة محاكاة (مفرعة) عن البيئة الأساسية

// Staging المرحلة
// يتم في بيئة المرحلة، وهي تقليد دقيق لبيئة الإنتاج
