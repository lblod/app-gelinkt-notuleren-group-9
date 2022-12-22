;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PUBLICATIE GN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this is a shared domain file, maintained in https://github.com/lblod/domain-files
(define-resource versioned-agenda ()
  :class (s-prefix "ext:VersionedAgenda")
  :properties `((:state :string ,(s-prefix "ext:stateString"))
                (:content :string ,(s-prefix "ext:content"))
                (:kind :string ,(s-prefix "ext:agendaKind")))
  :has-many `(
              (signed-resource :via ,(s-prefix "ext:signsAgenda")
                               :inverse t
                               :as "signed-resources")
              )
  :has-one `(
             (published-resource :via ,(s-prefix "ext:publishesAgenda")
                                 :inverse t
                                 :as "published-resource")
             (editor-document :via ,(s-prefix "prov:wasDerivedFrom")
                              :as "editor-document")
             (document-container :via ,(s-prefix "ext:hasVersionedAgenda")
                                 :inverse t
                                 :as "document-container")
             )
  :resource-base (s-url "http://data.lblod.info/prepublished-agendas/")
  :features '(include-uri)
  :on-path "versioned-agendas")

(define-resource versioned-besluiten-lijst ()
  :class (s-prefix "ext:VersionedBesluitenLijst")
  :properties `((:state :string ,(s-prefix "ext:stateString"))
                (:content :string ,(s-prefix "ext:content")))
  :has-many `((signed-resource :via ,(s-prefix "ext:signsBesluitenlijst")
                               :inverse t
                               :as "signed-resources"))
  :has-one `((published-resource :via ,(s-prefix "ext:publishesBesluitenlijst")
                                 :inverse t
                                 :as "published-resource")
             (editor-document :via ,(s-prefix "prov:wasDerivedFrom")
                              :as "editor-document")
             (zitting :via ,(s-prefix "besluit:heeftBesluitenlijst")
                                 :inverse t
                                 :as "zitting"))
  :resource-base (s-url "http://data.lblod.info/prepublished-besluiten-lijsten/")
  :features '(include-uri)
  :on-path "versioned-besluiten-lijsten")

(define-resource versioned-notulen ()
  :class (s-prefix "ext:VersionedNotulen")
  :properties `((:state :string ,(s-prefix "ext:stateString"))
                (:content :string ,(s-prefix "ext:content"))
                (:public-content :string ,(s-prefix "ext:publicContent"))
                (:public-behandelingen :uri-set ,(s-prefix "ext:publicBehandeling"))
                (:kind :string ,(s-prefix "ext:notulenKind")))
  :has-many `((signed-resource :via ,(s-prefix "ext:signsNotulen")
                               :inverse t
                               :as "signed-resources"))
  :has-one `((published-resource :via ,(s-prefix "ext:publishesNotulen")
                                 :inverse t
                                 :as "published-resource")
             (editor-document :via ,(s-prefix "prov:wasDerivedFrom")
                              :as "editor-document")
             (zitting :via ,(s-prefix "ext:hasVersionedNotulen")
                                 :inverse t
                                 :as "zitting"))
  :resource-base (s-url "http://data.lblod.info/prepublished-notulen/")
  :features '(include-uri)
  :on-path "versioned-notulen")

(define-resource versioned-behandeling ()
  :class (s-prefix "ext:VersionedBehandeling")
  :properties `((:state :string ,(s-prefix "ext:stateString"))
                (:content :string ,(s-prefix "ext:content")))
  :has-many `((signed-resource :via ,(s-prefix "ext:signsBehandeling")
                               :inverse t
                               :as "signed-resources"))
  :has-one `((published-resource :via ,(s-prefix "ext:publishesBehandeling")
                                 :inverse t
                                 :as "published-resource")
             (zitting :via ,(s-prefix "ext:hasVersionedBehandeling")
                                 :inverse t
                                 :as "zitting")
             (behandeling-van-agendapunt :via ,(s-prefix "ext:behandeling")
                                         :as "behandeling"))
  :resource-base (s-url "http://data.lblod.info/prepublished-behandeling/")
  :features '(include-uri)
  :on-path "versioned-behandelingen")

(define-resource versioned-regulatory-statement ()
  :class (s-prefix "ext:VersionedRegulatoryStatement")
  :properties `((:state :string ,(s-prefix "ext:stateString")))
  :has-many `((signed-resource :via ,(s-prefix "ext:signsRegulatoryStatement")
                               :inverse t
                               :as "signed-resources"))
  :has-one `((published-resource :via ,(s-prefix "ext:publishesRegulatoryStatement")
                                 :inverse t
                                 :as "published-resource")
             (versioned-behandeling :via ,(s-prefix "ext:hasVersionedRegulatoryStatement")
                                 :inverse t
                                 :as "versioned-behandeling")
             (editor-document :via ,(s-prefix "ext:regulatoryStatement")
                                         :as "regulatory-statement")
             (file :via ,(s-prefix "prov:generated")
                            :as "file"))
  :resource-base (s-url "http://data.lblod.info/prepublished-regulatory-statement/")
  :features '(include-uri)
  :on-path "versioned-regulatory-statements")


(define-resource signed-resource ()
  :class (s-prefix "sign:SignedResource")
  :properties `((:content :string ,(s-prefix "sign:text"))
                (:hash-value :string ,(s-prefix "sign:hashValue"))
                (:created-on :datetime ,(s-prefix "dct:created")))
  :has-one `((blockchain-status :via ,(s-prefix "sign:status")
                                :as "status")
             (agenda :via ,(s-prefix "ext:signsAgenda")
                               :as "agenda")
             (versioned-besluiten-lijst :via ,(s-prefix "ext:signsBesluitenlijst")
                                        :as "versioned-besluiten-lijst")
             (versioned-notulen :via ,(s-prefix "ext:signsNotulen")
                                :as "versioned-notulen")
             (versioned-behandeling :via ,(s-prefix "ext:signsBehandeling")
                                    :as "versioned-behandeling")
             (gebruiker :via ,(s-prefix "sign:signatory")
                        :as "gebruiker"))
  :resource-base (s-url "http://data.lblod.info/signed-resources/")
  :features '(include-uri)
  :on-path "signed-resources")

(define-resource published-resource ()
  :class (s-prefix "sign:PublishedResource")
  :properties `((:content :string ,(s-prefix "sign:text"))
                (:hash-value :string ,(s-prefix "sign:hashValue"))
                (:created-on :datetime ,(s-prefix "dct:created"))
                (:submission-status :uri ,(s-prefix "ext:submissionStatus")))
  :has-one `((blockchain-status :via ,(s-prefix "sign:status")
                                :as "status")
             (agenda :via ,(s-prefix "ext:publishesAgenda")
                               :as "agenda")
             (versioned-besluiten-lijst :via ,(s-prefix "ext:publishesBesluitenlijst")
                                        :as "versioned-besluiten-lijst")
             (versioned-behandeling :via ,(s-prefix "ext:publishesBehandeling")
                                        :as "versioned-behandeling")
             (versioned-notulen :via ,(s-prefix "ext:publiseshNotulen")
                                :as "versioned-notulen")
             (gebruiker :via ,(s-prefix "sign:signatory")
                        :as "gebruiker"))
  :resource-base (s-url "http://data.lblod.info/published-resources/")
  :features '(include-uri)
  :on-path "published-resources")


(define-resource blockchain-status ()
  :class (s-prefix "sign:BlockchainStatus")
  :properties `((:title :string ,(s-prefix "dct:title"))
                (:description :string ,(s-prefix "dct:description")))
  :resource-base (s-url "http://data.lblod.info/blockchain-statuses/")
  :features '(include-uri)
  :on-path "blockchain-statuses")

(define-resource notulen ()
  :class (s-prefix "ext:Notulen")
  :properties `((:inhoud :string ,(s-prefix "prov:value")))
  :has-one `((zitting :via ,(s-prefix "besluit:heeftNotulen")
                      :inverse t
                      :as "zitting"))
  :has-many `((published-resource :via ,(s-prefix "prov:wasDerivedFrom")
                                  :as "publications"))
  :resource-base (s-url "http://data.lblod.info/id/notulen/")
  :features '(include-uri)
  :on-path "notulen")

(define-resource agenda ()
  :class (s-prefix "bv:Agenda")
  :properties `(
                (:inhoud :string ,(s-prefix "prov:value"))
                (:agenda-status :string ,(s-prefix "bv:agendaStatus"))
                (:agenda-type :string ,(s-prefix "bv:agendaType"))
                (:rendered-content :string ,(s-prefix "ext:renderedContent"))
                )
  :has-one `(
             (zitting :via ,(s-prefix "bv:isAgendaVoor")
                      :as "zitting")
             (published-resource :via ,(s-prefix "ext:publishesAgenda")
                                 :inverse t
                                 :as "published-resource")
             )
  :has-many `(
              (agendapunt :via ,(s-prefix "dct:isPartOf")
                          :inverse t
                          :as "agendapunten")
              (signed-resource :via ,(s-prefix "ext:signsAgenda")
                               :inverse t
                               :as "signed-resources")
              )
  :resource-base (s-url "http://data.lblod.info/id/agendas/")
  :features '(include-uri)
  :on-path "agendas")

(define-resource uittreksel ()
  :class (s-prefix "ext:Uittreksel")
  :properties `((:inhoud :string ,(s-prefix "prov:value")))
  :has-one `((published-resource :via ,(s-prefix "prov:wasDerivedFrom")
                                 :as "publication")
             (behandeling-van-agendapunt :via ,(s-prefix "ext:uittrekselBvap")
                                         :as "behandeling-van-agendapunt")
             (zitting :via ,(s-prefix "ext:uittreksel")
                      :inverse t
                      :as "zitting"))
  :resource-base (s-url "http://data.lblod.info/id/uittreksels/")
  :features '(include-uri)
  :on-path "uittreksels")

(define-resource besluitenlijst ()
  :class (s-prefix "ext:Besluitenlijst")
  :properties `((:inhoud :string ,(s-prefix "prov:value"))
                (:publicatiedatum :date ,(s-prefix "eli:date_publication")))
  :has-one `((published-resource :via ,(s-prefix "prov:wasDerivedFrom")
                                 :as "publication")
             (zitting :via ,(s-prefix "ext:besluitenlijst")
                      :inverse t
                      :as "zitting"))
  :has-many `((besluit :via ,(s-prefix "ext:besluitenlijstBesluit")
                                          :as "besluiten"))
  :resource-base (s-url "http://data.lblod.info/id/besluitenlijsten/")
  :features '(include-uri)
  :on-path "besluitenlijsten")

(define-resource publication-status-code ()
  :class (s-prefix "bibo:DocumentStatus")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:scope-note :string ,(s-prefix "skos:scopeNote")))
  :resource-base (s-url "http://data.vlaanderen.be/id/concept/MandatarisStatusCode/")
  :features '(include-uri)
  :on-path "publication-status-codes")
