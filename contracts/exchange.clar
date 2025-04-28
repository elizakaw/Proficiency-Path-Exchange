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
x