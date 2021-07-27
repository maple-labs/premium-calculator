// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { PremiumCalc } from "../PremiumCalc.sol";

contract MockLoan {

    uint256 public principalOwed;

    constructor (uint256 _principalOwed) public {
        principalOwed = _principalOwed;
    }

}

contract PremiumCalcTest is DSTest {

    function test_calcType() external {
        assertTrue(new PremiumCalc(999_999).calcType() == uint8(12));
    }

    function test_name() external {
        assertTrue(new PremiumCalc(999_999).name() == "FLAT");
    }

    function test_lateFee() external {
        assertEq(new PremiumCalc(999_999).premiumFee(), 999_999);
    }

    function assert_premiumPayment(
        uint256 principalOwed,
        uint256 premiumFee,
        uint256 expectedTotal,
        uint256 expectedPrincipalOwed,
        uint256 expectedInterest
    ) internal {
        MockLoan loan           = new MockLoan(principalOwed);
        PremiumCalc premiumCalc = new PremiumCalc(premiumFee);
        (uint256 actualTotal, uint256 actualPrincipalOwed, uint256 actualInterest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(actualTotal,         expectedTotal);
        assertEq(actualPrincipalOwed, expectedPrincipalOwed);
        assertEq(actualInterest,      expectedInterest);
    }

    function test_getPremiumPayment() external {
        assert_premiumPayment(1,   1,      1,   1,   0);
        assert_premiumPayment(10,  10,     10,  10,  0);
        assert_premiumPayment(100, 100,    101, 100, 1);
        assert_premiumPayment(800, 500,    840, 800, 40);
        assert_premiumPayment(0,   10_000, 0,   0,   0);
    }

}
