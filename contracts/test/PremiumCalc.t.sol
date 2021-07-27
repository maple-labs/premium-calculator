// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { PremiumCalc } from "../PremiumCalc.sol";

contract LoanWithPrincipalOwed {

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

    function test_getPremiumPayment() external {
        PremiumCalc premiumCalc;
        LoanWithPrincipalOwed loan;
        uint256 total;
        uint256 principalOwed;
        uint256 interest;

        loan                             = new LoanWithPrincipalOwed(1);
        premiumCalc                      = new PremiumCalc(1);
        (total, principalOwed, interest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(total,         1);
        assertEq(principalOwed, 1);
        assertEq(interest,      0);

        loan                             = new LoanWithPrincipalOwed(10);
        premiumCalc                      = new PremiumCalc(10);
        (total, principalOwed, interest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(total,         10);
        assertEq(principalOwed, 10);
        assertEq(interest,      0);

        loan                             = new LoanWithPrincipalOwed(100);
        premiumCalc                      = new PremiumCalc(100);
        (total, principalOwed, interest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(total,         101);
        assertEq(principalOwed, 100);
        assertEq(interest,      1);

        loan                             = new LoanWithPrincipalOwed(800);
        premiumCalc                      = new PremiumCalc(500);
        (total, principalOwed, interest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(total,         840);
        assertEq(principalOwed, 800);
        assertEq(interest,      40);

        loan                             = new LoanWithPrincipalOwed(0);
        premiumCalc                      = new PremiumCalc(10_000);
        (total, principalOwed, interest) = premiumCalc.getPremiumPayment(address(loan));
        assertEq(total,         0);
        assertEq(principalOwed, 0);
        assertEq(interest,      0);
    }

}
