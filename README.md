# ProficiencyPath Exchange

## Overview
ProficiencyPath Exchange is a blockchain-powered decentralized marketplace designed to connect specialists with organizations and project creators. The platform facilitates the creation and management of individual profiles, organization registrations, and project listings, all underpinned by secure and transparent smart contracts.

The exchange allows specialists to showcase their skills and experience, while organizations can post projects seeking the right expertise. Built on the Clarity smart contract language, this platform ensures efficient and secure interactions.

## Features
- **Specialist Registration:** Specialists can create profiles detailing their name, skills, location, and bio.
- **Organization Registration:** Organizations can register and list their profiles, including name, industry, and location.
- **Project Listings:** Organizations can create, modify, and delete project listings with required skill sets and descriptions.
- **Profile Management:** Users (specialists and organizations) can update or delete their profiles.
- **Error Handling:** Standardized error codes for issues such as profile not found, invalid data, or already existing entries.

## Smart Contract Structure
### Data Repositories
- **Organization Registry:** Stores registered organization profiles.
- **Specialist Registry:** Stores individual specialist profiles.
- **Project Registry:** Stores available project listings.

### Error Codes
- **ERR-NOT-FOUND**: Data not found.
- **ERR-ALREADY-EXISTS**: Profile or project already exists.
- **ERR-INVALID-SKILLS**: Invalid skills list.
- **ERR-INVALID-LOCATION**: Invalid location input.
- **ERR-INVALID-BIO**: Invalid biography.
- **ERR-INVALID-PROJECT**: Invalid project data.

### Functions
- **Organization Functions:** Register, modify, and delete organization profiles.
- **Project Functions:** Create, modify, and delete project listings.
- **Specialist Functions:** Register, modify, and delete specialist profiles.
- **Query Functions:** Retrieve organization, project, and specialist profile data.

## Usage
1. **Registering as a Specialist:**
   Use the `register-specialist` function to create a profile with your name, skills, location, and bio.

2. **Registering an Organization:**
   Use the `register-organization` function to register your organization with relevant details.

3. **Creating a Project:**
   Use the `create-project` function to list a project with a description, location, and skill requirements.

4. **Modifying or Deleting Profiles and Projects:**
   Modify or delete existing profiles and projects using the respective functions.

## Deployment
This project is deployed using the Clarity language on the Stacks blockchain. To interact with the contract, you need a Stacks wallet and access to the Stacks blockchain.
