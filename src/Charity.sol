// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Charity {
    /**
     * @dev Struct representing a donation.
     * @param donor The address of the donor.
     * @param amount The amount of the donation.
     * @param isVerified Flag indicating if the donation is verified.
     */
    struct Donation {
        address donor;
        uint256 amount;
        bool isVerified;
    }

    mapping(address => Donation) public donations;

    address public charity;
    uint256 public totalDonations;

    event DonationMade(address indexed donor, uint256 amount);
    event DonationVerified(address indexed donor);

    constructor() {
        charity = msg.sender;
        totalDonations = 0;
    }

    /**
     * Modifier that restricts the execution of a function to be called only by the charity.
     *
     * @dev The function can only be called by the address assigned as the charity.
     * @dev If the caller is not the charity, the function will revert with an error message.
     */
    modifier onlyCharity() {
        require(
            msg.sender == charity,
            "Only the charity can call this function"
        );
        _;
    }

    /**
     * @dev Function for making a donation.
     * @dev The function requires the donation amount to be greater than zero.
     * @dev The function creates a new Donation struct with the donor's address, donation amount, and verification status.
     * @dev The function updates the donations mapping with the new donation.
     * @dev The function increases the totalDonations counter by the donation amount.
     * @dev The function emits a DonationMade event with the donor's address and donation amount.
     */
    function makeDonation() public payable {
        require(msg.value > 0, "Donations amount must be greater than zero");
        Donation memory donation = Donation(msg.sender, msg.value, false);

        donations[msg.sender] = donation;
        totalDonations += msg.value;

        emit DonationMade(msg.sender, msg.value);
    }

    /**
     * @dev Function for verifying a donation.
     * @param _donor The address of the donor whose donation needs to be verified.
     * @dev The function checks if the donation exists and has not been verified already.
     * @dev If the donation is valid, the function updates the verification status to true.
     * @dev The function emits a DonationVerified event with the donor's address.
     */
    function verifyDonation(address _donor) public onlyCharity {
        Donation storage donation = donations[_donor];
        require(donation.donor != address(0), "Donation not found");
        require(!donation.isVerified, "Donation has already been veridied");

        donation.isVerified = true;

        emit DonationVerified(_donor);
    }

    function getDonation(address _donor) public view returns (uint256, bool) {
        Donation memory donation = donations[_donor];
        return (donation.amount, donation.isVerified);
    }
}
