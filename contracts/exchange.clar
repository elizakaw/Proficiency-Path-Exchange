;; ========================================================
;; ProficiencyPath Exchange: Decentralized Expertise Marketplace
;; A blockchain-powered ecosystem connecting specialists with assignments
;; This contract facilitates profile creation, organization registration, 
;; and project listing with comprehensive identity management.
;; ========================================================


;; ==================== DATA STORAGE ====================

;; Repository for registered organizations
(define-map organization-registry
    principal
    {
        name: (string-ascii 100),
        industry: (string-ascii 50),
        location: (string-ascii 100)
    }
)

;; Repository for available projects
(define-map project-registry
    principal
    {
        title: (string-ascii 100),
        description: (string-ascii 500),
        creator: principal,
        location: (string-ascii 100),
        requirements: (list 10 (string-ascii 50))
    }
)

;; Repository for individual specialist profiles
(define-map specialist-registry
    principal
    {
        name: (string-ascii 100),
        skills: (list 10 (string-ascii 50)),
        location: (string-ascii 100),
        bio: (string-ascii 500)
    }
)



;; ==================== ERROR CODES ====================

;; Standard protocol error definitions
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-SKILLS (err u400))
(define-constant ERR-INVALID-LOCATION (err u401))
(define-constant ERR-INVALID-BIO (err u402))
(define-constant ERR-INVALID-PROJECT (err u403))
(define-constant ERR-PROFILE-NOT-FOUND (err u404))



;; ==================== ORGANIZATION FUNCTIONS ====================

;; Register a new organization
(define-public (register-organization 
    (name (string-ascii 100))
    (industry (string-ascii 50))
    (location (string-ascii 100)))

    (let
        (
            (user tx-sender)
            (existing-org (map-get? organization-registry user))
        )
        ;; Verify organization doesn't already exist
        (if (is-none existing-org)
            (begin
                ;; Validate all required fields
                (if (or 
                        (is-eq name "")
                        (is-eq industry "")
                        (is-eq location "")
                    )
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Store the new organization profile
                        (map-set organization-registry user
                            {
                                name: name,
                                industry: industry,
                                location: location
                            }
                        )
                        (ok "Organization successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing organization profile
(define-public (modify-organization-profile 
    (name (string-ascii 100))
    (industry (string-ascii 50))
    (location (string-ascii 100)))

    (let
        (
            (user tx-sender)
            (existing-org (map-get? organization-registry user))
        )
        ;; Verify organization exists
        (if (is-some existing-org)
            (begin
                ;; Validate all required fields
                (if (or 
                        (is-eq name "")
                        (is-eq industry "")
                        (is-eq location "")
                    )
                    (err ERR-INVALID-LOCATION)
                    (begin
                        ;; Update the organization profile
                        (map-set organization-registry user
                            {
                                name: name,
                                industry: industry,
                                location: location
                            }
                        )
                        (ok "Organization profile successfully modified.")
                    )
                )
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)

;; Delete an existing organization profile
(define-public (delete-organization-profile)
    (let
        (
            (user tx-sender)
            (existing-org (map-get? organization-registry user))
        )
        ;; Verify organization exists
        (if (is-some existing-org)
            (begin
                ;; Remove the organization profile
                (map-delete organization-registry user)
                (ok "Organization profile successfully deleted.")
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)

;; ==================== PROJECT FUNCTIONS ====================

;; Create a new project listing
(define-public (create-project 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))

    (let
        (
            (user tx-sender)
            (existing-project (map-get? project-registry user))
        )
        ;; Verify project doesn't already exist
        (if (is-none existing-project)
            (begin
                ;; Validate all required fields
                (if (or 
                        (is-eq title "")
                        (is-eq description "")
                        (is-eq location "")
                        (is-eq (len requirements) u0)
                    )
                    (err ERR-INVALID-PROJECT)
                    (begin
                        ;; Store the new project listing
                        (map-set project-registry user
                            {
                                title: title,
                                description: description,
                                creator: user,
                                location: location,
                                requirements: requirements
                            }
                        )
                        (ok "Project successfully created.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing project listing
(define-public (modify-project 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))

    (let
        (
            (user tx-sender)
            (existing-project (map-get? project-registry user))
        )
        ;; Verify project exists
        (if (is-some existing-project)
            (begin
                ;; Validate all required fields
                (if (or 
                        (is-eq title "")
                        (is-eq description "")
                        (is-eq location "")
                        (is-eq (len requirements) u0)
                    )
                    (err ERR-INVALID-PROJECT)
                    (begin
                        ;; Update the project listing
                        (map-set project-registry user
                            {
                                title: title,
                                description: description,
                                creator: user,
                                location: location,
                                requirements: requirements
                            }
                        )
                        (ok "Project successfully updated.")
                    )
                )
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)

;; Delete an existing project listing
(define-public (delete-project)
    (let
        (
            (user tx-sender)
            (existing-project (map-get? project-registry user))
        )
        ;; Verify project exists
        (if (is-some existing-project)
            (begin
                ;; Remove the project listing
                (map-delete project-registry user)
                (ok "Project successfully deleted.")
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)


;; ==================== QUERY FUNCTIONS ====================

;; Retrieve specialist profile information
(define-read-only (get-specialist-profile (user-id principal))
    (match (map-get? specialist-registry user-id)
        profile-data (ok profile-data)
        ERR-NOT-FOUND
    )
)

;; Retrieve organization information
(define-read-only (get-organization-profile (user-id principal))
    (match (map-get? organization-registry user-id)
        org-data (ok org-data)
        ERR-NOT-FOUND
    )
)

;; Retrieve project listing details
(define-read-only (get-project-details (project-id principal))
    (match (map-get? project-registry project-id)
        project-data (ok project-data)
        ERR-NOT-FOUND
    )
)

;; ==================== SPECIALIST FUNCTIONS ====================

;; Register a new specialist profile
(define-public (register-specialist 
    (name (string-ascii 100))
    (skills (list 10 (string-ascii 50)))
    (location (string-ascii 100))
    (bio (string-ascii 500)))

    (let
        (
            (user tx-sender)
            (existing-profile (map-get? specialist-registry user))
        )
        ;; Verify profile doesn't already exist
        (if (is-none existing-profile)
            (begin
                ;; Validate all required fields
                (if (or 
                        (is-eq name "")
                        (is-eq location "")
                        (is-eq (len skills) u0)
                        (is-eq bio "")
                    )
                    (err ERR-INVALID-BIO)
                    (begin
                        ;; Store the new specialist profile
                        (map-set specialist-registry user
                            {
                                name: name,
                                skills: skills,
                                location: location,
                                bio: bio
                            }
                        )
                        (ok "Specialist profile successfully registered.")
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Modify an existing specialist profile
(define-public (modify-specialist-profile 
    (name (string-ascii 100))
    (skills (list 10 (string-ascii 50)))
    (location (string-ascii 100))
    (bio (string-ascii 500)))

    (let
        (
            (user tx-sender)
            (existing-profile (map-get? specialist-registry user))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Validate all required information
                (if (or 
                        (is-eq name "")
                        (is-eq location "")
                        (is-eq (len skills) u0)
                        (is-eq bio "")
                    )
                    (err ERR-INVALID-BIO)
                    (begin
                        ;; Update the specialist profile
                        (map-set specialist-registry user
                            {
                                name: name,
                                skills: skills,
                                location: location,
                                bio: bio
                            }
                        )
                        (ok "Specialist profile successfully modified.")
                    )
                )
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)

;; Delete an existing specialist profile
(define-public (delete-specialist-profile)
    (let
        (
            (user tx-sender)
            (existing-profile (map-get? specialist-registry user))
        )
        ;; Verify profile exists
        (if (is-some existing-profile)
            (begin
                ;; Remove the specialist profile
                (map-delete specialist-registry user)
                (ok "Specialist profile successfully deleted.")
            )
            (err ERR-PROFILE-NOT-FOUND)
        )
    )
)

