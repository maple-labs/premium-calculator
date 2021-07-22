pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./PremiumCalculator.sol";

contract PremiumCalculatorTest is DSTest {
    PremiumCalculator calculator;

    function setUp() public {
        calculator = new PremiumCalculator();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
