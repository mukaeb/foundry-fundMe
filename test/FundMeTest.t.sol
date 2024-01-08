// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    //fundme نحن -> عقد الإختبار -> عقد الإختبار بينشر
    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinValueUSDisFiveDollar() public {
        assertEq(fundMe.MIN_VALUE_USD(), 5e18);
    }

    function testOwnerIsMessageSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testGetVersion() public {
        assertEq(fundMe.getVersion(), 4);
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
