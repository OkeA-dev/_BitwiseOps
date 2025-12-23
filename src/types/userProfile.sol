// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.24;

type UserProfile is uint256;

using UserProfileLibrary for UserProfile global;

library UserProfileLibrary {
    // 1. Define your masks (like BORROW_INDEX_MASK in the example)
    uint256 internal constant USERID_MASK = (1 << 32) - 1; // bits 0-31
    uint256 internal constant ACOUNTAGE_MASK = ((1 << 16) - 1) << 32; // bits 32-47
    uint256 internal constant REPUTATIONSCORE_MASK = ((1 << 24) - 1) << 48; // bits 48-63
    uint256 internal constant FLAGS_MASK = ((1 << 8) - 1) << 72; // bits 72-79
    // 2. Create a storeUserProfile function that packs all 4 fields

    function storeUserProfile(uint256 _userId, uint256 _accountAge, uint256 _reputationScore, uint256 _flags)
        internal
        pure
        returns (UserProfile result)
    {
        assembly {
            result := add(add(add(_userId, shl(32, _accountAge)), shl(48, _reputationScore)), shl(72, _flags))
        }
    }
    // 3. Write 4 update functions (one for each field)
    //    - updateUserId
    function updateUserId(UserProfile self, uint256 _userId) internal pure returns (UserProfile result) {
        assembly {
            let cleared := and(self, not(USERID_MASK))
            result := or(cleared, _userId)
        }
    }
    //    - updateAccountAge
    function updateAccountAge(UserProfile self, uint256 _accountAge) internal pure returns (UserProfile result) {
        assembly {
            let cleared := and(self, not(ACOUNTAGE_MASK))
            result := or(cleared, shl(32, _accountAge))
        }
    }
    //    - updateReputationScore
    function updateReputationScore(UserProfile self, uint256 _reputationScore) internal pure returns (UserProfile result) {
        assembly {
            let cleared := and(self, not(REPUTATIONSCORE_MASK))
            result := or(cleared, shl(48, _reputationScore))
        }
    }
    //    - updateFlags
    function updateFlags(UserProfile self, uint256 _flags) internal pure returns (UserProfile result) {
        assembly {
            let cleared := and(self, not(FLAGS_MASK))
            result := or(cleared, shl(72, _flags))
        }
    }

    // 4. Write 4 getter functions to extract each field
    //    - userId
    function userId(UserProfile self) internal pure returns (uint256 result) {
        assembly {
            result := and(self, USERID_MASK)
        }
    }
    //    - accountAge
    function accountAge(UserProfile self) internal pure returns (uint256 result) {
        assembly {
            result := shr(and(self, ACOUNTAGE_MASK), 32)
        }
    }
    //    - reputationScore
    function reputationScore(UserProfile self) internal pure returns (uint256 result) {
        assembly {
            result := shr(and(self, REPUTATIONSCORE_MASK), 48)
    }
    }
    //    - flags   
    function flags(UserProfile self) internal pure returns (uint256 result) {
        assembly {
            result := shr(and(self, FLAGS_MASK), 72)
        }
    }
}
